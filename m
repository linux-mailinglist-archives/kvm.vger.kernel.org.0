Return-Path: <kvm+bounces-70724-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MObcLwcdi2nSPwAAu9opvQ
	(envelope-from <kvm+bounces-70724-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 12:56:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B2A111A773
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 12:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 849263010228
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 11:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9F1328621;
	Tue, 10 Feb 2026 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="OfLDBiJA"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2858B327210;
	Tue, 10 Feb 2026 11:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770724590; cv=none; b=kwsF/vLC8SrJC5y7kmByaFuvZLLJAs15pebv2vg+kFJGL3IObdsaIuQDqoEEMyMQMfuy+jG3+41yW5xDxVpogsAssfHolWhg+b/dkSyg3pymlDozcCo9a0ks0pdHHEb2kBmDxVBmMzJL7avWVPKHsFxg2oWE59FOf6WHaId3658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770724590; c=relaxed/simple;
	bh=Yo8YP4vHjJ4hEg9AbOfOtM2Z+nDKRd5pcI6fnAVLnIY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PhXFVjvRKmQh3U84/f7eyZdZnKFTBJaQCX6ivQ/GMp/y2JoW+09JWvb1Oa8ADUifu3tzh3OLI/5Y+FejoXZ7KRTUGq5oLM7Jf2n4NjU0WKR0ksJuYl0LuGMhAxp2EGJsNcYd8NGCfvrkW6pu5cL57RDaTnXnNo8YFhVnfngxCII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=OfLDBiJA; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9vZbm7DohkcY4Y/SHLRgKmVJUVCDPSoK0RAQtH1sxQU=;
	b=OfLDBiJAQXqJSv0wtOAn4GR79N6xC/sEifPkadLR51xGYan47B5lKFHZiMH/Zo1hEjoKhyg80
	bWBeZozVKn07bY10jpW67sz43VkgsRfd4hstigDMw+PqTDG9EJqOG4vJcN8woE9IdQYF5K1YSdb
	4QZdj+9pgHI6eYmtgc1VyUY=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4f9KfM13Hjz1prmC;
	Tue, 10 Feb 2026 19:51:39 +0800 (CST)
Received: from kwepemj200018.china.huawei.com (unknown [7.202.194.30])
	by mail.maildlp.com (Postfix) with ESMTPS id 6E92740569;
	Tue, 10 Feb 2026 19:56:19 +0800 (CST)
Received: from kwepemj100010.china.huawei.com (7.202.194.4) by
 kwepemj200018.china.huawei.com (7.202.194.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Feb 2026 19:56:19 +0800
Received: from kwepemj100010.china.huawei.com ([7.202.194.4]) by
 kwepemj100010.china.huawei.com ([7.202.194.4]) with mapi id 15.02.1544.036;
 Tue, 10 Feb 2026 19:56:19 +0800
From: Zhangjiaji <zhangjiaji1@huawei.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Wangqinxiao (Tom)" <wangqinxiao@huawei.com>,
	zhangyashu <zhangyashu2@h-partners.com>, "wangyanan (Y)"
	<wangyanan55@huawei.com>
Subject: Re: Re: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found
 by KASAN/Syzkaller fuzz test (v5.10.0)
Thread-Topic: Re: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found
 by KASAN/Syzkaller fuzz test (v5.10.0)
Thread-Index: AdyahCoX5kIguQEfT9W/nj6C2WNJ5A==
Date: Tue, 10 Feb 2026 11:56:18 +0000
Message-ID: <67a2f20537354628bcb835586a7c6255@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	FAKE_REPLY(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[huawei.com,quarantine];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70724-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:mid,huawei.com:dkim,huawei.com:email,qemu.org:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[huawei.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhangjiaji1@huawei.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 1B2A111A773
X-Rspamd-Action: no action

> I think there's a not-completely-awful solution buried in this gigantic c=
esspool.
> The only time KVM uses on-stack variables is for qword or smaller accesse=
s, i.e.
> 8 bytes in size or less.  For larger fragments, e.g. AVX to/from MMIO, th=
e target
> value will always be an operand in the emulator context.  And so rather t=
han
> disallow stack variables, for "small" fragments, we can rework the handli=
ng to
> copy the value to/from each fragment on-demand instead of stashing a poin=
ter to
> the value.

Since we can store the frag->val in struct kvm_mmio_fragment,
why not just point frag->data to it? This Way we can save a lot code about
(frag->data =3D=3D NULL).

Though this patch will block any read-into-stack calls, we can add a specia=
l path
in function emulator_read_write handling feasible read-into-stack calls -- =
the
target is released just after emulator_read_write returns.

---
 arch/x86/kvm/x86.c       | 9 ++++++++-
 include/linux/kvm_host.h | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72d37c8930ad..12d53d441a39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8197,7 +8197,14 @@ static int emulator_read_write_onepage(unsigned long=
 addr, void *val,
 	WARN_ON(vcpu->mmio_nr_fragments >=3D KVM_MAX_MMIO_FRAGMENTS);
 	frag =3D &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
 	frag->gpa =3D gpa;
-	frag->data =3D val;
+	if (bytes > 8u || ! write) {
+		if (WARN_ON_ONCE(object_is_on_stack(val)))
+			return X86EMUL_UNHANDLEABLE;
+		frag->data =3D val;
+	} else {
+		memcpy(&frag->val, val, bytes);
+		frag->data =3D &frag->val;
+	}
 	frag->len =3D bytes;
 	return X86EMUL_CONTINUE;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..f8419d632394 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -320,7 +320,8 @@ static inline bool kvm_vcpu_can_poll(ktime_t cur, ktime=
_t stop)
 struct kvm_mmio_fragment {
 	gpa_t gpa;
 	void *data;
-	unsigned len;
+	unsigned int len;
+	u64 val;
 };
=20
 struct kvm_vcpu {

base-commit: 72c395024dac5e215136cbff793455f065603b06
--=20
2.33.0




-----Original Message-----
From: Sean Christopherson <seanjc@google.com>=20
Sent: Tuesday, February 10, 2026 4:22 AM
To: Zhangjiaji <zhangjiaji1@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>; kvm@vger.kernel.org; linux-kernel@=
vger.kernel.org; Wangqinxiao (Tom) <wangqinxiao@huawei.com>; zhangyashu <zh=
angyashu2@h-partners.com>; wangyanan (Y) <wangyanan55@huawei.com>
Subject: Re: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found by=
 KASAN/Syzkaller fuzz test (v5.10.0)

On Fri, Feb 06, 2026, Sean Christopherson wrote:
> On Mon, Feb 02, 2026, Zhangjiaji wrote:
> > Syzkaller hit 'KASAN: use-after-free Read in complete_emulated_mmio' bu=
g.
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KASAN: use-after-free in complete_emulated_mmio+0x305/0x420
> > Read of size 1 at addr ffff888009c378d1 by task syz-executor417/984
> >=20
> > CPU: 1 PID: 984 Comm: syz-executor417 Not tainted 5.10.0-182.0.0.95.h26=
27.eulerosv2r13.x86_64 #3 Hardware name: QEMU Standard PC (i440FX + PIIX, 1=
996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014 Call Tra=
ce:
> > dump_stack+0xbe/0xfd
> > print_address_description.constprop.0+0x19/0x170
> > __kasan_report.cold+0x6c/0x84
> > kasan_report+0x3a/0x50
> > check_memory_region+0xfd/0x1f0
> > memcpy+0x20/0x60
> > complete_emulated_mmio+0x305/0x420
> > kvm_arch_vcpu_ioctl_run+0x63f/0x6d0
> > kvm_vcpu_ioctl+0x413/0xb20
> > __se_sys_ioctl+0x111/0x160
> > do_syscall_64+0x30/0x40
> > entry_SYSCALL_64_after_hwframe+0x67/0xd1
> > RIP: 0033:0x42477d

...

> > I've analyzed the Syzkaller output and the complete_emulated_mmio()=20
> > code path.  The buggy address is created in em_enter(), where it=20
> > passes its local variable `ulong rbp` to emulate_push(), finally=20
> > ends in
> > emulator_read_write_onepage() putting the address into
> > vcpu->mmio_fragments[].data .  The bug happens when kvm guest=20
> > vcpu->executes an
> > "enter" instruction, and top of the stack crosses the mem page.  In=20
> > that case, the em_enter() function cannot complete the instruction=20
> > within itself, but leave the rest data (which is in the other page)=20
> > to complete_emulated_mmio().  When complete_emulated_mmio() starts,=20
> > em_enter() has exited, so local variable `ulong rbp` is also=20
> > released.  Now
> > complete_emulated_mmio() trys to access vcpu->mmio_fragments[].data=20
> > , and the bug happened.
> >=20
> > any idea?
>=20
> Egad, sorry!  I had reproduced this shortly after you sent the report=20
> and prepped a fix, but got distracted and lost this in my inbox.
>=20
> Can you test this on your end?  I repro'd by modifying a KVM-Unit-Test=20
> and hacking KVM to tweak the stack, so I haven't confirmed the syzkaller =
version.
>=20
> It's a bit gross, as it abuses an unused field as scratch space, but=20
> AFAICT that's "fine".  The alternative would be add a dedicated field, wh=
ich seems like overkill?
>=20
> I'm also going to try and add a WARN to detect if the @val parameter=20
> passed to
> emulator_read_write() is ever on the kernel stack, e.g. to help detect=20
> lurking bugs like this one without relying on kasahn.
>=20
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c index=20
> c8e292e9a24d..dacef51c2565 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1897,13 +1897,12 @@ static int em_enter(struct x86_emulate_ctxt *ctxt=
)
>         int rc;
>         unsigned frame_size =3D ctxt->src.val;
>         unsigned nesting_level =3D ctxt->src2.val & 31;
> -       ulong rbp;
> =20
>         if (nesting_level)
>                 return X86EMUL_UNHANDLEABLE;
> =20
> -       rbp =3D reg_read(ctxt, VCPU_REGS_RBP);
> -       rc =3D emulate_push(ctxt, &rbp, stack_size(ctxt));
> +       ctxt->memop.orig_val =3D reg_read(ctxt, VCPU_REGS_RBP);
> +       rc =3D emulate_push(ctxt, &ctxt->memop.orig_val,=20
> + stack_size(ctxt));
>         if (rc !=3D X86EMUL_CONTINUE)
>                 return rc;
>         assign_masked(reg_rmw(ctxt, VCPU_REGS_RBP), reg_read(ctxt,=20
> VCPU_REGS_RSP),

*sigh*

This isn't going to work.  Or rather, it's far from a complete fix, as ther=
e are several other instructions and flows that use stack variables to serv=
ice reads and writes.  Hacking all of them to not use stack variables isn't=
 feasible, as flows like emulate_iret_real() and em_popa() perform multiple=
 acceses, i.e.
hijacking an unused operand simply won't work.

I'm tempted to go with a straightforward "fix" of rejecting userspace MMIO =
if the destination is on the stack, e.g. like so:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index db3f393192d9..11=
3287612acd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8272,6 +8272,9 @@ static int emulator_read_write(struct x86_emulate_ctx=
t *ctxt,
        if (!vcpu->mmio_nr_fragments)
                return X86EMUL_CONTINUE;
=20
+       if (object_is_on_stack(val))
+               return X86EMUL_UNHANDLEABLE;
+
        gpa =3D vcpu->mmio_fragments[0].gpa;
=20
        vcpu->mmio_needed =3D 1;

But I hate how arbitrary that is, and I'm somewhat concerned that it could =
break existing setups.

I think there's a not-completely-awful solution buried in this gigantic ces=
spool.
The only time KVM uses on-stack variables is for qword or smaller accesses,=
 i.e.
8 bytes in size or less.  For larger fragments, e.g. AVX to/from MMIO, the =
target value will always be an operand in the emulator context.  And so rat=
her than disallow stack variables, for "small" fragments, we can rework the=
 handling to copy the value to/from each fragment on-demand instead of stas=
hing a pointer to the value.

This needs a _lot_ more documentation, the SEV-ES flows aren't converted, a=
nd there is a ton of cleanup that can and should be done on top, but this a=
ppears to work.

Note the "clobber" in complete_emulated_mmio() to fill 4096 bytes of the st=
ack with 0xaa, i.e. to simulate some of the stack being "freed".

---
 arch/x86/kvm/kvm_emulate.h |   8 +++
 arch/x86/kvm/x86.c         | 125 +++++++++++++++++++++++++++----------
 include/linux/kvm_host.h   |   6 +-
 3 files changed, 103 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h index =
fb3dab4b5a53..f735158af05e 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -284,6 +284,14 @@ struct fetch_cache {
 	u8 *end;
 };
=20
+/*
+ * To complete userspace MMIO and I/O reads, KVM re-emulates=20
+(NO_DECODE) the
+ * _entire_ instruction to propagate the read data to its final destinatio=
n.
+ * To avoid re-reading values from memory and/or getting "stuck" on the=20
+access
+ * that triggered an exit to userspace, KVM caches all values that have=20
+been
+ * read for a given instruction, and reads from this cache instead of=20
+reading
+ * from guest memory or from userspace.
+ */
 struct read_cache {
 	u8 data[1024];
 	unsigned long pos;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index db3f393192d9..1b=
99de3e3236 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8109,7 +8109,7 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t =
gpa,  }
=20
 struct read_write_emulator_ops {
-	int (*read_write_prepare)(struct kvm_vcpu *vcpu, void *val,
+	int (*read_mmio_fragment)(struct kvm_vcpu *vcpu, void *val,
 				  int bytes);
 	int (*read_write_emulate)(struct kvm_vcpu *vcpu, gpa_t gpa,
 				  void *val, int bytes);
@@ -8120,16 +8120,37 @@ struct read_write_emulator_ops {
 	bool write;
 };
=20
-static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
+static int read_mmio_fragment(struct kvm_vcpu *vcpu, void *val, int=20
+bytes)
 {
-	if (vcpu->mmio_read_completed) {
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes,
-			       vcpu->mmio_fragments[0].gpa, val);
-		vcpu->mmio_read_completed =3D 0;
-		return 1;
+	struct kvm_mmio_fragment *frag;
+	unsigned int len =3D bytes;
+
+	while (len && vcpu->mmio_head_fragment < vcpu->mmio_tail_fragment) {
+		int i =3D vcpu->mmio_head_fragment++;
+
+		if (WARN_ON_ONCE(i >=3D vcpu->mmio_nr_fragments))
+			break;
+
+		frag =3D &vcpu->mmio_fragments[i];
+		if (!frag->data) {
+			if (WARN_ON_ONCE(len < frag->len || frag->len > 8u)) {
+				pr_warn("len =3D %u, bytes =3D %u, frag->len =3D %u, gpa =3D %llx, rip=
 =3D %lx\n",
+					len, bytes, frag->len, frag->gpa, kvm_rip_read(vcpu));
+				break;
+			}
+
+			memcpy(val, &frag->val, min(8u, frag->len));
+		}
+
+		val +=3D frag->len;
+		len -=3D min(len, frag->len);
 	}
=20
-	return 0;
+	if ((int)len =3D=3D bytes)
+		return 0;
+
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes, frag->gpa, val);
+	return 1;
 }
=20
 static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa, @@ -8150,6 +8171=
,11 @@ static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, v=
oid *val)
 	return vcpu_mmio_write(vcpu, gpa, bytes, val);  }
=20
+static void *mmio_frag_data(struct kvm_mmio_fragment *frag) {
+	return frag->data ?: &frag->val;
+}
+
 static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  void *val, int bytes)
 {
@@ -8162,12 +8188,12 @@ static int write_exit_mmio(struct kvm_vcpu *vcpu, g=
pa_t gpa,  {
 	struct kvm_mmio_fragment *frag =3D &vcpu->mmio_fragments[0];
=20
-	memcpy(vcpu->run->mmio.data, frag->data, min(8u, frag->len));
+	memcpy(vcpu->run->mmio.data, mmio_frag_data(frag), min(8u,=20
+frag->len));
 	return X86EMUL_CONTINUE;
 }
=20
 static const struct read_write_emulator_ops read_emultor =3D {
-	.read_write_prepare =3D read_prepare,
+	.read_mmio_fragment =3D read_mmio_fragment,
 	.read_write_emulate =3D read_emulate,
 	.read_write_mmio =3D vcpu_mmio_read,
 	.read_write_exit_mmio =3D read_exit_mmio, @@ -8226,7 +8252,13 @@ static i=
nt emulator_read_write_onepage(unsigned long addr, void *val,
 	WARN_ON(vcpu->mmio_nr_fragments >=3D KVM_MAX_MMIO_FRAGMENTS);
 	frag =3D &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
 	frag->gpa =3D gpa;
-	frag->data =3D val;
+	if (bytes > 8u) {
+		frag->data =3D val;
+	} else {
+		frag->data =3D NULL;
+		if (write)
+			memcpy(&frag->val, val, bytes);
+	}
 	frag->len =3D bytes;
 	return X86EMUL_CONTINUE;
 }
@@ -8241,11 +8273,16 @@ static int emulator_read_write(struct x86_emulate_c=
txt *ctxt,
 	gpa_t gpa;
 	int rc;
=20
-	if (ops->read_write_prepare &&
-		  ops->read_write_prepare(vcpu, val, bytes))
+	if (WARN_ON_ONCE(bytes > 8u && object_is_on_stack(val)))
+		return X86EMUL_UNHANDLEABLE;
+
+	if (ops->read_mmio_fragment &&
+	    ops->read_mmio_fragment(vcpu, val, bytes))
 		return X86EMUL_CONTINUE;
=20
 	vcpu->mmio_nr_fragments =3D 0;
+	vcpu->mmio_head_fragment =3D 0;
+	vcpu->mmio_tail_fragment =3D 0;
=20
 	/* Crossing a page boundary? */
 	if (((addr + bytes - 1) ^ addr) & PAGE_MASK) { @@ -8275,7 +8312,6 @@ stat=
ic int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	gpa =3D vcpu->mmio_fragments[0].gpa;
=20
 	vcpu->mmio_needed =3D 1;
-	vcpu->mmio_cur_fragment =3D 0;
=20
 	vcpu->run->mmio.len =3D min(8u, vcpu->mmio_fragments[0].len);
 	vcpu->run->mmio.is_write =3D vcpu->mmio_is_write =3D ops->write; @@ -1183=
2,42 +11868,61 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu) =
 {
 	struct kvm_run *run =3D vcpu->run;
 	struct kvm_mmio_fragment *frag;
-	unsigned len;
+	unsigned int len;
+	u8 clobber[4096];
=20
-	BUG_ON(!vcpu->mmio_needed);
+	memset(clobber, 0xaa, sizeof(clobber));
+
+	if (WARN_ON_ONCE(!vcpu->mmio_needed))
+		return -EIO;
+
+	/* Complete MMIO for the current fragment. */
+	frag =3D &vcpu->mmio_fragments[vcpu->mmio_tail_fragment];
=20
-	/* Complete previous fragment */
-	frag =3D &vcpu->mmio_fragments[vcpu->mmio_cur_fragment];
 	len =3D min(8u, frag->len);
 	if (!vcpu->mmio_is_write)
-		memcpy(frag->data, run->mmio.data, len);
+		memcpy(mmio_frag_data(frag), run->mmio.data, len);
=20
 	if (frag->len <=3D 8) {
 		/* Switch to the next fragment. */
 		frag++;
-		vcpu->mmio_cur_fragment++;
+		vcpu->mmio_tail_fragment++;
 	} else {
+		if (WARN_ON_ONCE(!frag->data))
+			return -EIO;
+=09
 		/* Go forward to the next mmio piece. */
 		frag->data +=3D len;
 		frag->gpa +=3D len;
 		frag->len -=3D len;
 	}
=20
-	if (vcpu->mmio_cur_fragment >=3D vcpu->mmio_nr_fragments) {
+	if (vcpu->mmio_tail_fragment >=3D vcpu->mmio_nr_fragments) {
 		vcpu->mmio_needed =3D 0;
+		WARN_ON_ONCE(vcpu->mmio_head_fragment);
=20
-		/* FIXME: return into emulator if single-stepping.  */
-		if (vcpu->mmio_is_write)
+		/*
+		 * Don't re-emulate the instruction for MMIO writes, as KVM has
+		 * already committed all side effects (and the emulator simply
+		 * isn't equi)
+		 *
+		 * FIXME: Return into emulator if single-stepping.
+		 */
+		if (vcpu->mmio_is_write) {
+			vcpu->mmio_tail_fragment =3D 0;
 			return 1;
-		vcpu->mmio_read_completed =3D 1;
+		}
+
 		return complete_emulated_io(vcpu);
 	}
=20
+	len =3D min(8u, frag->len);
+
 	run->exit_reason =3D KVM_EXIT_MMIO;
 	run->mmio.phys_addr =3D frag->gpa;
 	if (vcpu->mmio_is_write)
-		memcpy(run->mmio.data, frag->data, min(8u, frag->len));
-	run->mmio.len =3D min(8u, frag->len);
+		memcpy(run->mmio.data, mmio_frag_data(frag), len);
+	run->mmio.len =3D len;
 	run->mmio.is_write =3D vcpu->mmio_is_write;
 	vcpu->arch.complete_userspace_io =3D complete_emulated_mmio;
 	return 0;
@@ -14247,15 +14302,15 @@ static int complete_sev_es_emulated_mmio(struct k=
vm_vcpu *vcpu)
 	BUG_ON(!vcpu->mmio_needed);
=20
 	/* Complete previous fragment */
-	frag =3D &vcpu->mmio_fragments[vcpu->mmio_cur_fragment];
+	frag =3D &vcpu->mmio_fragments[vcpu->mmio_tail_fragment];
 	len =3D min(8u, frag->len);
-	if (!vcpu->mmio_is_write)
+	if (!vcpu->mmio_is_write && frag->data)
 		memcpy(frag->data, run->mmio.data, len);
=20
 	if (frag->len <=3D 8) {
 		/* Switch to the next fragment. */
 		frag++;
-		vcpu->mmio_cur_fragment++;
+		vcpu->mmio_tail_fragment++;
 	} else {
 		/* Go forward to the next mmio piece. */
 		frag->data +=3D len;
@@ -14263,7 +14318,7 @@ static int complete_sev_es_emulated_mmio(struct kvm=
_vcpu *vcpu)
 		frag->len -=3D len;
 	}
=20
-	if (vcpu->mmio_cur_fragment >=3D vcpu->mmio_nr_fragments) {
+	if (vcpu->mmio_tail_fragment >=3D vcpu->mmio_nr_fragments) {
 		vcpu->mmio_needed =3D 0;
=20
 		// VMG change, at this point, we're always done @@ -14303,13 +14358,14 @=
@ int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int =
bytes,
=20
 	/*TODO: Check if need to increment number of frags */
 	frag =3D vcpu->mmio_fragments;
-	vcpu->mmio_nr_fragments =3D 1;
 	frag->len =3D bytes;
 	frag->gpa =3D gpa;
 	frag->data =3D data;
=20
 	vcpu->mmio_needed =3D 1;
-	vcpu->mmio_cur_fragment =3D 0;
+	vcpu->mmio_nr_fragments =3D 1;
+	vcpu->mmio_head_fragment =3D 0;
+	vcpu->mmio_tail_fragment =3D 0;
=20
 	vcpu->run->mmio.phys_addr =3D gpa;
 	vcpu->run->mmio.len =3D min(8u, frag->len); @@ -14342,13 +14398,14 @@ int=
 kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
=20
 	/*TODO: Check if need to increment number of frags */
 	frag =3D vcpu->mmio_fragments;
-	vcpu->mmio_nr_fragments =3D 1;
 	frag->len =3D bytes;
 	frag->gpa =3D gpa;
 	frag->data =3D data;
=20
 	vcpu->mmio_needed =3D 1;
-	vcpu->mmio_cur_fragment =3D 0;
+	vcpu->mmio_nr_fragments =3D 1;
+	vcpu->mmio_head_fragment =3D 0;
+	vcpu->mmio_tail_fragment =3D 0;
=20
 	vcpu->run->mmio.phys_addr =3D gpa;
 	vcpu->run->mmio.len =3D min(8u, frag->len); diff --git a/include/linux/kv=
m_host.h b/include/linux/kvm_host.h index 782f4d670793..be4b9de5b8c9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -320,7 +320,8 @@ static inline bool kvm_vcpu_can_poll(ktime_t cur, ktime=
_t stop)  struct kvm_mmio_fragment {
 	gpa_t gpa;
 	void *data;
-	unsigned len;
+	u64 val;
+	unsigned int len;
 };
=20
 struct kvm_vcpu {
@@ -356,7 +357,8 @@ struct kvm_vcpu {
 	int mmio_needed;
 	int mmio_read_completed;
 	int mmio_is_write;
-	int mmio_cur_fragment;
+	int mmio_head_fragment;
+	int mmio_tail_fragment;
 	int mmio_nr_fragments;
 	struct kvm_mmio_fragment mmio_fragments[KVM_MAX_MMIO_FRAGMENTS];
 #endif

base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
--

