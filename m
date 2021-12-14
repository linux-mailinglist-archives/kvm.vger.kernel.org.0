Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C34474D35
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 22:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhLNV2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 16:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhLNV2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 16:28:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C503CC061574;
        Tue, 14 Dec 2021 13:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DVAe+o5FB71rpOJk9Q6+MOtnII8Wblri6r9tHRuHuJI=; b=4FKi8/4/AIeqximvgG3RVvmHzr
        zoDErtT97+ldY3XP+IkNeMJ2Jf4mxXVBq8RiZvVase+1TTOtMcrsCBDqmgUqTc5nzOVyueR6n/SbI
        Eq3sNB9NSOy5FYtTpnldxu62WYKvwn+MQxnB33E42HkHqNljSHLsn0BOyZl4HBLmi+Q+Suv91JCoY
        frx9Y4qxmUtgD9gGVfN2OXuGKQ7PAZUagF7bK+0w82P8p/WwD20ynhrMFMSptt5MwlaKpNoDu4FDO
        tGqcpsLgXpZ8onELYpW511Z6RBF0kkqTIH5EOUpxNZsVOPH9gWOQmKT38wH1KoRbfL6efNtgtfqLp
        DcchLZIA==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxFKv-00Fq2i-Pd; Tue, 14 Dec 2021 21:27:50 +0000
Message-ID: <6f50a325344218167a9cef12d82bccc7cded3b52.camel@infradead.org>
Subject: Re: [PATCH v2 1/7] x86/apic/x2apic: Fix parallel handling of
 cluster_mask
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Date:   Tue, 14 Dec 2021 21:27:44 +0000
In-Reply-To: <YbjQCf29BH7aTblP@google.com>
References: <20211214123250.88230-1-dwmw2@infradead.org>
         <20211214123250.88230-2-dwmw2@infradead.org> <YbjQCf29BH7aTblP@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-rN1sJo5DqdkK0GQ60BSz"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-rN1sJo5DqdkK0GQ60BSz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-12-14 at 17:10 +0000, Sean Christopherson wrote:
> On Tue, Dec 14, 2021, David Woodhouse wrote:
> > -static int alloc_clustermask(unsigned int cpu, int node)
> > +static int alloc_clustermask(unsigned int cpu, u32 cluster, int node)
> >  {
> > +	struct cluster_mask *cmsk =3D NULL;
> > +	unsigned int cpu_i;
> > +	u32 apicid;
> > +
> >  	if (per_cpu(cluster_masks, cpu))
> >  		return 0;
> > -	/*
> > -	 * If a hotplug spare mask exists, check whether it's on the right
> > -	 * node. If not, free it and allocate a new one.
> > +
> > +	/* For the hotplug case, don't always allocate a new one */
> > +	for_each_present_cpu(cpu_i) {
> > +		apicid =3D apic->cpu_present_to_apicid(cpu_i);
> > +		if (apicid !=3D BAD_APICID && apicid >> 4 =3D=3D cluster) {
> > +			cmsk =3D per_cpu(cluster_masks, cpu_i);
> > +			if (cmsk)
> > +				break;
> > +		}
> > +	}
> > +	if (!cmsk) {
> > +		cmsk =3D kzalloc_node(sizeof(*cmsk), GFP_KERNEL, node);
> > +	}
> > +	if (!cmsk)
> > +		return -ENOMEM;
>=20
> This can be,
>=20
> 	if (!cmsk) {
> 		cmsk =3D kzalloc_node(sizeof(*cmsk), GFP_KERNEL, node);
> 		if (!cmsk)
> 			return -ENOMEM;
> 	}
>=20
> which IMO is more intuitive, and it also "fixes" the unnecessary braces i=
n thew
> initial check.
>=20
> > +
> > +	cmsk->node =3D node;
> > +	cmsk->clusterid =3D cluster;
> > +
> > +	per_cpu(cluster_masks, cpu) =3D cmsk;
> > +
> > +        /*
> > +	 * As an optimisation during boot, set the cluster_mask for *all*
> > +	 * present CPUs at once, to prevent *each* of them having to iterate
> > +	 * over the others to find the existing cluster_mask.
> >  	 */
> > -	if (cluster_hotplug_mask) {
> > -		if (cluster_hotplug_mask->node =3D=3D node)
> > -			return 0;
> > -		kfree(cluster_hotplug_mask);
> > +	if (system_state < SYSTEM_RUNNING) {
>=20
> This can be
>=20
> 	if (system_state >=3D SYSTEM_RUNNING)
> 		return 0;
>=20
> to reduce indentation below.
>=20
> > +		for_each_present_cpu(cpu) {
>=20
> Reusing @cpu here is all kinds of confusing.
>=20
> > +			u32 apicid =3D apic->cpu_present_to_apicid(cpu);
>=20
> This shadows apicid.  That's completely unnecessary.
>=20
> > +			if (apicid !=3D BAD_APICID && apicid >> 4 =3D=3D cluster) {
>=20
> A helper for retrieving the cluster from a cpu would dedup at least three=
 instances
> of this pattern.

Thanks. Let's just lift the whole thing out into a separate function.
And actually now I come to stare harder at it, the whole of the struct
cluster_mask can go away too. Looks a bit more like this now:


---
 arch/x86/kernel/apic/x2apic_cluster.c | 108 +++++++++++++++-----------
 1 file changed, 62 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x=
2apic_cluster.c
index e696e22d0531..e116dfaf5922 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -9,11 +9,7 @@
=20
 #include "local.h"
=20
-struct cluster_mask {
-	unsigned int	clusterid;
-	int		node;
-	struct cpumask	mask;
-};
+#define apic_cluster(apicid) ((apicid) >> 4)
=20
 /*
  * __x2apic_send_IPI_mask() possibly needs to read
@@ -23,8 +19,7 @@ struct cluster_mask {
 static u32 *x86_cpu_to_logical_apicid __read_mostly;
=20
 static DEFINE_PER_CPU(cpumask_var_t, ipi_mask);
-static DEFINE_PER_CPU_READ_MOSTLY(struct cluster_mask *, cluster_masks);
-static struct cluster_mask *cluster_hotplug_mask;
+static DEFINE_PER_CPU_READ_MOSTLY(struct cpumask *, cluster_masks);
=20
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
@@ -60,10 +55,10 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int =
vector, int apic_dest)
=20
 	/* Collapse cpus in a cluster so a single IPI per cluster is sent */
 	for_each_cpu(cpu, tmpmsk) {
-		struct cluster_mask *cmsk =3D per_cpu(cluster_masks, cpu);
+		struct cpumask *cmsk =3D per_cpu(cluster_masks, cpu);
=20
 		dest =3D 0;
-		for_each_cpu_and(clustercpu, tmpmsk, &cmsk->mask)
+		for_each_cpu_and(clustercpu, tmpmsk, cmsk)
 			dest |=3D x86_cpu_to_logical_apicid[clustercpu];
=20
 		if (!dest)
@@ -71,7 +66,7 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int ve=
ctor, int apic_dest)
=20
 		__x2apic_send_IPI_dest(dest, vector, APIC_DEST_LOGICAL);
 		/* Remove cluster CPUs from tmpmask */
-		cpumask_andnot(tmpmsk, tmpmsk, &cmsk->mask);
+		cpumask_andnot(tmpmsk, tmpmsk, cmsk);
 	}
=20
 	local_irq_restore(flags);
@@ -105,55 +100,76 @@ static u32 x2apic_calc_apicid(unsigned int cpu)
=20
 static void init_x2apic_ldr(void)
 {
-	struct cluster_mask *cmsk =3D this_cpu_read(cluster_masks);
-	u32 cluster, apicid =3D apic_read(APIC_LDR);
-	unsigned int cpu;
+	struct cpumask *cmsk =3D this_cpu_read(cluster_masks);
=20
-	x86_cpu_to_logical_apicid[smp_processor_id()] =3D apicid;
+	BUG_ON(!cmsk);
=20
-	if (cmsk)
-		goto update;
-
-	cluster =3D apicid >> 16;
-	for_each_online_cpu(cpu) {
-		cmsk =3D per_cpu(cluster_masks, cpu);
-		/* Matching cluster found. Link and update it. */
-		if (cmsk && cmsk->clusterid =3D=3D cluster)
-			goto update;
+	cpumask_set_cpu(smp_processor_id(), cmsk);
+}
+
+/*
+ * As an optimisation during boot, set the cluster_mask for *all*
+ * present CPUs at once, to prevent *each* of them having to iterate
+ * over the others to find the existing cluster_mask.
+ */
+static void prefill_clustermask(struct cpumask *cmsk, u32 cluster)
+{
+	int cpu;
+
+	for_each_present_cpu(cpu) {
+		u32 apicid =3D apic->cpu_present_to_apicid(cpu);
+		if (apicid !=3D BAD_APICID && apic_cluster(apicid) =3D=3D cluster) {
+			struct cpumask **cpu_cmsk =3D &per_cpu(cluster_masks, cpu);
+
+			BUG_ON(*cpu_cmsk && *cpu_cmsk !=3D cmsk);
+			*cpu_cmsk =3D cmsk;
+		}
 	}
-	cmsk =3D cluster_hotplug_mask;
-	cmsk->clusterid =3D cluster;
-	cluster_hotplug_mask =3D NULL;
-update:
-	this_cpu_write(cluster_masks, cmsk);
-	cpumask_set_cpu(smp_processor_id(), &cmsk->mask);
 }
=20
-static int alloc_clustermask(unsigned int cpu, int node)
+static int alloc_clustermask(unsigned int cpu, u32 cluster, int node)
 {
+	struct cpumask *cmsk =3D NULL;
+	unsigned int cpu_i;
+	u32 apicid;
+
 	if (per_cpu(cluster_masks, cpu))
 		return 0;
-	/*
-	 * If a hotplug spare mask exists, check whether it's on the right
-	 * node. If not, free it and allocate a new one.
-	 */
-	if (cluster_hotplug_mask) {
-		if (cluster_hotplug_mask->node =3D=3D node)
-			return 0;
-		kfree(cluster_hotplug_mask);
+
+	/* For the hotplug case, don't always allocate a new one */
+	if (system_state >=3D SYSTEM_RUNNING) {
+		for_each_present_cpu(cpu_i) {
+			apicid =3D apic->cpu_present_to_apicid(cpu_i);
+			if (apicid !=3D BAD_APICID && apic_cluster(apicid) =3D=3D cluster) {
+				cmsk =3D per_cpu(cluster_masks, cpu_i);
+				if (cmsk)
+					break;
+			}
+		}
+	}
+	if (!cmsk) {
+		cmsk =3D kzalloc_node(sizeof(*cmsk), GFP_KERNEL, node);
+		if (!cmsk)
+			return -ENOMEM;
 	}
=20
-	cluster_hotplug_mask =3D kzalloc_node(sizeof(*cluster_hotplug_mask),
-					    GFP_KERNEL, node);
-	if (!cluster_hotplug_mask)
-		return -ENOMEM;
-	cluster_hotplug_mask->node =3D node;
+	per_cpu(cluster_masks, cpu) =3D cmsk;
+
+	if (system_state < SYSTEM_RUNNING)
+		prefill_clustermask(cmsk, cluster);
+
 	return 0;
 }
=20
 static int x2apic_prepare_cpu(unsigned int cpu)
 {
-	if (alloc_clustermask(cpu, cpu_to_node(cpu)) < 0)
+	u32 phys_apicid =3D apic->cpu_present_to_apicid(cpu);
+	u32 cluster =3D apic_cluster(phys_apicid);
+	u32 logical_apicid =3D (cluster << 16) | (1 << (phys_apicid & 0xf));
+
+	x86_cpu_to_logical_apicid[cpu] =3D logical_apicid;
+
+	if (alloc_clustermask(cpu, cluster, cpu_to_node(cpu)) < 0)
 		return -ENOMEM;
 	if (!zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL))
 		return -ENOMEM;
@@ -162,10 +178,10 @@ static int x2apic_prepare_cpu(unsigned int cpu)
=20
 static int x2apic_dead_cpu(unsigned int dead_cpu)
 {
-	struct cluster_mask *cmsk =3D per_cpu(cluster_masks, dead_cpu);
+	struct cpumask *cmsk =3D per_cpu(cluster_masks, dead_cpu);
=20
 	if (cmsk)
-		cpumask_clear_cpu(dead_cpu, &cmsk->mask);
+		cpumask_clear_cpu(dead_cpu, cmsk);
 	free_cpumask_var(per_cpu(ipi_mask, dead_cpu));
 	return 0;
 }
--=20
2.31.1


--=-rN1sJo5DqdkK0GQ60BSz
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
MjE0MjEyNzQ0WjAvBgkqhkiG9w0BCQQxIgQg0E1mafA+MzczbJfxoNYJcOgOPjlp1S8DkXPxyER2
bg0wgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAI9JQH0LZ8CUFQr3wRWWW4vQPSW/Y1Qg/mW4Gh7/uakYZK5Tc8xuHErlPNoIlYFA
QMNY2ryVqRoGGtdLRLI1HsqVl2huzZHNqOh8D0BX/DJ0cDhvCSGLnpatVEb+4WYYFpCp2RAE/bTM
ijsEdkpKfTaM81F82+13vVCfLj0pvoXaKKX4VzB0eNsW6NOLVcaKcvpfPwQ+J9okm0ng+1fvLlr3
pPDYomTmNfYBkBGj5hnrhLndpQ72+38ZhfQ+cmnTFElUXaFj70hl0nGWTdEm7zpJpRkshslf7mrN
5mMOJmjvT0cjBliozNfeqsueReSUzKxW94hXhyUV023l4+PatdEAAAAAAAA=


--=-rN1sJo5DqdkK0GQ60BSz--

