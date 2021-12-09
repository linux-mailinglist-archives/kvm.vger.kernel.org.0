Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89F846F3D9
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 20:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhLITZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 14:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhLITZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 14:25:40 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C557C061746;
        Thu,  9 Dec 2021 11:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pU88T4/RSl8s0u2eJGbYKbzqQveJ5xPUAkCA2hdvrD0=; b=SMXHIQuvVhoEsW4O46wwbsr8Sy
        wvtHUogq/D0WnO1DKjvfP2Ae+GqTfUedXGeyazhJFDpbfbXuifDMGXPD8X1YGo6b0z8koOhxrppbv
        wFzaEwgTqhET7oYX+9nwC2H4g667HRhfspQbk+og/kLzwPFtsaMThTGvGw+mtq3MHCjGFCNlqo9e2
        XAQ94+VQLO/gOMLsC1NQy+FtvL58O85K7oE+pZG3vm3VU2knJG8ZtWfu+mbVNqRMtTeRXoqF9UJ1o
        uVc1GxyzEgLDDpDFsh/tiF8KaTsUMasMULTxeDdZFtI8K3KtWojjmzGh9X+BI28pJzCw2VgovUe2B
        QI+rG8bQ==;
Received: from 54-240-197-234.amazon.com ([54.240.197.234] helo=freeip.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvOzI-00HLZ1-KR; Thu, 09 Dec 2021 19:21:53 +0000
Message-ID: <5b086c9e5a92bb91e6f4c086e6d01e380a7491af.camel@infradead.org>
Subject: [PATCH v1.1 02/11] rcu: Kill rnp->ofl_seq and use only
 rcu_state.ofl_lock for exclusion
From:   David Woodhouse <dwmw2@infradead.org>
To:     Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Date:   Thu, 09 Dec 2021 19:21:48 +0000
In-Reply-To: <dfa110f0-8fd0-0f37-2c37-89eccac1ad08@quicinc.com>
References: <20211209150938.3518-1-dwmw2@infradead.org>
         <20211209150938.3518-3-dwmw2@infradead.org>
         <dfa110f0-8fd0-0f37-2c37-89eccac1ad08@quicinc.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-2roYrSWSjtd7eUJwbGzu"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-2roYrSWSjtd7eUJwbGzu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

If we allow architectures to bring APs online in parallel, then we end
up requiring rcu_cpu_starting() to be reentrant. But currently, the
manipulation of rnp->ofl_seq is not thread-safe.

However, rnp->ofl_seq is also fairly much pointless anyway since both
rcu_cpu_starting() and rcu_report_dead() hold rcu_state.ofl_lock for
fairly much the whole time that rnp->ofl_seq is set to an odd number
to indicate that an operation is in progress.

So drop rnp->ofl_seq completely, and use only rcu_state.ofl_lock.

This has a couple of minor complexities: lockdep will complain when we
take rcu_state.ofl_lock, and currently accepts the 'excuse' of having
an odd value in rnp->ofl_seq. So switch it to an arch_spinlock_t to
avoid that false positive complaint. Since we're killing rnp->ofl_seq
of course that 'excuse' has to be changed too, so make it check for
arch_spin_is_locked(rcu_state.ofl_lock).

There's no arch_spin_lock_irqsave() so we have to manually save and
restore local interrupts around the locking.

At Paul's request based on Neeraj's analysis, make rcu_gp_init not just=20
wait but *exclude* any CPU online/offline activity, which was fairly
much true already by virtue of it holding rcu_state.ofl_lock.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
If we're going to split the series up and let the various patches take
their own paths to Linus, I'll just repost this one alone as 'v1.1'.

 kernel/rcu/tree.c | 71 ++++++++++++++++++++++++-----------------------
 kernel/rcu/tree.h |  4 +--
 2 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index ef8d36f580fc..2e1ae611be98 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -91,7 +91,7 @@ static struct rcu_state rcu_state =3D {
 	.abbr =3D RCU_ABBR,
 	.exp_mutex =3D __MUTEX_INITIALIZER(rcu_state.exp_mutex),
 	.exp_wake_mutex =3D __MUTEX_INITIALIZER(rcu_state.exp_wake_mutex),
-	.ofl_lock =3D __RAW_SPIN_LOCK_UNLOCKED(rcu_state.ofl_lock),
+	.ofl_lock =3D __ARCH_SPIN_LOCK_UNLOCKED,
 };
=20
 /* Dump rcu_node combining tree at boot to verify correct setup. */
@@ -1168,7 +1168,15 @@ bool rcu_lockdep_current_cpu_online(void)
 	preempt_disable_notrace();
 	rdp =3D this_cpu_ptr(&rcu_data);
 	rnp =3D rdp->mynode;
-	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) || READ_ONCE(rnp->ofl_seq) & =
0x1)
+	/*
+	 * Strictly, we care here about the case where the current CPU is
+	 * in rcu_cpu_starting() and thus has an excuse for rdp->grpmask
+	 * not being up to date. So arch_spin_is_locked() might have a
+	 * false positive if it's held by some *other* CPU, but that's
+	 * OK because that just means a false *negative* on the warning.
+	 */
+	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) ||
+	    arch_spin_is_locked(&rcu_state.ofl_lock))
 		ret =3D true;
 	preempt_enable_notrace();
 	return ret;
@@ -1731,7 +1739,6 @@ static void rcu_strict_gp_boundary(void *unused)
  */
 static noinline_for_stack bool rcu_gp_init(void)
 {
-	unsigned long firstseq;
 	unsigned long flags;
 	unsigned long oldmask;
 	unsigned long mask;
@@ -1774,22 +1781,17 @@ static noinline_for_stack bool rcu_gp_init(void)
 	 * of RCU's Requirements documentation.
 	 */
 	WRITE_ONCE(rcu_state.gp_state, RCU_GP_ONOFF);
+	/* Exclude CPU hotplug operations. */
 	rcu_for_each_leaf_node(rnp) {
-		// Wait for CPU-hotplug operations that might have
-		// started before this grace period did.
-		smp_mb(); // Pair with barriers used when updating ->ofl_seq to odd valu=
es.
-		firstseq =3D READ_ONCE(rnp->ofl_seq);
-		if (firstseq & 0x1)
-			while (firstseq =3D=3D READ_ONCE(rnp->ofl_seq))
-				schedule_timeout_idle(1);  // Can't wake unless RCU is watching.
-		smp_mb(); // Pair with barriers used when updating ->ofl_seq to even val=
ues.
-		raw_spin_lock(&rcu_state.ofl_lock);
-		raw_spin_lock_irq_rcu_node(rnp);
+		local_irq_save(flags);
+		arch_spin_lock(&rcu_state.ofl_lock);
+		raw_spin_lock_rcu_node(rnp);
 		if (rnp->qsmaskinit =3D=3D rnp->qsmaskinitnext &&
 		    !rnp->wait_blkd_tasks) {
 			/* Nothing to do on this leaf rcu_node structure. */
-			raw_spin_unlock_irq_rcu_node(rnp);
-			raw_spin_unlock(&rcu_state.ofl_lock);
+			raw_spin_unlock_rcu_node(rnp);
+			arch_spin_unlock(&rcu_state.ofl_lock);
+			local_irq_restore(flags);
 			continue;
 		}
=20
@@ -1824,8 +1826,9 @@ static noinline_for_stack bool rcu_gp_init(void)
 				rcu_cleanup_dead_rnp(rnp);
 		}
=20
-		raw_spin_unlock_irq_rcu_node(rnp);
-		raw_spin_unlock(&rcu_state.ofl_lock);
+		raw_spin_unlock_rcu_node(rnp);
+		arch_spin_unlock(&rcu_state.ofl_lock);
+		local_irq_restore(flags);
 	}
 	rcu_gp_slow(gp_preinit_delay); /* Races with CPU hotplug. */
=20
@@ -4246,11 +4249,10 @@ void rcu_cpu_starting(unsigned int cpu)
=20
 	rnp =3D rdp->mynode;
 	mask =3D rdp->grpmask;
-	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
-	WARN_ON_ONCE(!(rnp->ofl_seq & 0x1));
+	local_irq_save(flags);
+	arch_spin_lock(&rcu_state.ofl_lock);
 	rcu_dynticks_eqs_online();
-	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
-	raw_spin_lock_irqsave_rcu_node(rnp, flags);
+	raw_spin_lock_rcu_node(rnp);
 	WRITE_ONCE(rnp->qsmaskinitnext, rnp->qsmaskinitnext | mask);
 	newcpu =3D !(rnp->expmaskinitnext & mask);
 	rnp->expmaskinitnext |=3D mask;
@@ -4263,15 +4265,18 @@ void rcu_cpu_starting(unsigned int cpu)
=20
 	/* An incoming CPU should never be blocking a grace period. */
 	if (WARN_ON_ONCE(rnp->qsmask & mask)) { /* RCU waiting on incoming CPU? *=
/
+		/* rcu_report_qs_rnp() *really* wants some flags to restore */
+		unsigned long flags2;
+		local_irq_save(flags2);
+
 		rcu_disable_urgency_upon_qs(rdp);
 		/* Report QS -after- changing ->qsmaskinitnext! */
-		rcu_report_qs_rnp(mask, rnp, rnp->gp_seq, flags);
+		rcu_report_qs_rnp(mask, rnp, rnp->gp_seq, flags2);
 	} else {
-		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
+		raw_spin_unlock_rcu_node(rnp);
 	}
-	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
-	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
-	WARN_ON_ONCE(rnp->ofl_seq & 0x1);
+	arch_spin_unlock(&rcu_state.ofl_lock);
+	local_irq_restore(flags);
 	smp_mb(); /* Ensure RCU read-side usage follows above initialization. */
 }
=20
@@ -4285,7 +4290,7 @@ void rcu_cpu_starting(unsigned int cpu)
  */
 void rcu_report_dead(unsigned int cpu)
 {
-	unsigned long flags;
+	unsigned long flags, seq_flags;
 	unsigned long mask;
 	struct rcu_data *rdp =3D per_cpu_ptr(&rcu_data, cpu);
 	struct rcu_node *rnp =3D rdp->mynode;  /* Outgoing CPU's rdp & rnp. */
@@ -4299,10 +4304,8 @@ void rcu_report_dead(unsigned int cpu)
=20
 	/* Remove outgoing CPU from mask in the leaf rcu_node structure. */
 	mask =3D rdp->grpmask;
-	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
-	WARN_ON_ONCE(!(rnp->ofl_seq & 0x1));
-	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
-	raw_spin_lock(&rcu_state.ofl_lock);
+	local_irq_save(seq_flags);
+	arch_spin_lock(&rcu_state.ofl_lock);
 	raw_spin_lock_irqsave_rcu_node(rnp, flags); /* Enforce GP memory-order gu=
arantee. */
 	rdp->rcu_ofl_gp_seq =3D READ_ONCE(rcu_state.gp_seq);
 	rdp->rcu_ofl_gp_flags =3D READ_ONCE(rcu_state.gp_flags);
@@ -4313,10 +4316,8 @@ void rcu_report_dead(unsigned int cpu)
 	}
 	WRITE_ONCE(rnp->qsmaskinitnext, rnp->qsmaskinitnext & ~mask);
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
-	raw_spin_unlock(&rcu_state.ofl_lock);
-	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
-	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
-	WARN_ON_ONCE(rnp->ofl_seq & 0x1);
+	arch_spin_unlock(&rcu_state.ofl_lock);
+	local_irq_restore(seq_flags);
=20
 	rdp->cpu_started =3D false;
 }
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 305cf6aeb408..aff4cc9303fb 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -56,8 +56,6 @@ struct rcu_node {
 				/*  Initialized from ->qsmaskinitnext at the */
 				/*  beginning of each grace period. */
 	unsigned long qsmaskinitnext;
-	unsigned long ofl_seq;	/* CPU-hotplug operation sequence count. */
-				/* Online CPUs for next grace period. */
 	unsigned long expmask;	/* CPUs or groups that need to check in */
 				/*  to allow the current expedited GP */
 				/*  to complete. */
@@ -358,7 +356,7 @@ struct rcu_state {
 	const char *name;			/* Name of structure. */
 	char abbr;				/* Abbreviated name. */
=20
-	raw_spinlock_t ofl_lock ____cacheline_internodealigned_in_smp;
+	arch_spinlock_t ofl_lock ____cacheline_internodealigned_in_smp;
 						/* Synchronize offline with */
 						/*  GP pre-initialization. */
 };
--=20
2.31.1


--=-2roYrSWSjtd7eUJwbGzu
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEx
MjA5MTkyMTQ4WjAvBgkqhkiG9w0BCQQxIgQgYTOzWo1Xj9JAYuDWWfoiFsQUSBIB98N10fdCAQSw
kBgwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAGBfZvTztDSHCzzaEL/XpRiKer1E3wouhv1A9fa+CrK2DJXJfx9cDqVu6RurDeeI
DqNxCaqu9wOWHb2TYpipBwPA2eDTV2jSvUaSzKJQ8+lUlmVH43YmQX7DO4UoupX1JDS6WXFaUPrk
kwL1YFyTCObbxwKU19dNeVNfQTERAZS5glcj1APc2k60aCjIXmSrebSTDT84lV2oIrHYGKLhlzeN
RvFR92xNqM7AV5X8yWLn9By7ulnw+sy6uCe7qEQ1y6k8F/rP3VYTjiBODcHWtRCIHOFtQqkbZeW4
iOdKY/PWNjJqanWNRqI++mOJ0mJyANiad0Hd5fBAOHpwkB7JN5YAAAAAAAA=


--=-2roYrSWSjtd7eUJwbGzu--

