Return-Path: <kvm+bounces-43536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC955A9121D
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 06:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FA705A1C24
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 04:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF721A2642;
	Thu, 17 Apr 2025 04:03:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A670EA920
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 04:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744862624; cv=none; b=FgxKyBLISCEeJf8N8kp/Hz3rDl8JVCo4jJEpPPfV/pz68LTAydxGl3iUMLnWraR+2GMi1B2YdXuXvlAGi2c8D49RVOypXEragsZ1r3IjGepd7MSx0QyM5KVeAKf7iiuQ9nAczFcz7lFNB73Vo6zWIKIKAbCSqz4NFMOclnE/3ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744862624; c=relaxed/simple;
	bh=K169F7mqqij9Sg2ntN2rhB/niz62i/xFzs4Nvmfj0B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pc1dZplEjBnvq09oOYF0uekv9h+pIJB9DOmf1rjtKAY7xYJGKv/YeOvP01FSA1ORaaWJZpCSUgUba3/p2plY3Fy21MrNiMs2fzWuOvWVR9NvxTzhGOi1+uYB2+OnaPtnoUnnT1IdAY+en+3Gq1jRr1hLuZDLtvMLAbxQwIYa6RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-01 (Coremail) with SMTP id qwCowAAHsADVewBolxVxCQ--.10339S2;
	Thu, 17 Apr 2025 11:56:08 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: seanjc@google.com
Cc: bp@alien8.de,
	chenyufeng@iie.ac.cn,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	x86@kernel.org
Subject: Re: [PATCH] kvm: x86: Don't report guest userspace emulation error to
 userspace in kvm_task_switch()
Date: Thu, 17 Apr 2025 11:55:55 +0800
Message-ID: <20250417035555.1672-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <Z_-6veJq79R-H0EH@google.com>
References: <Z_-6veJq79R-H0EH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:qwCowAAHsADVewBolxVxCQ--.10339S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFWDZw1kZFyDGr1kKw15urg_yoW5Jry5pr
	WIk3s7ua1DJ3ZYya4qg34fJr9Yv3WkGw15GryUGayjqw4jkFy3Xr4UK3y5Xa1fZr4fGa1F
	qFy0qFyfGF1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiBwoPEmgAS5S+MwAAsq

> On Wed, Apr 16, 2025, Chen Yufeng wrote:=0D
> > This patch prevents that emulation failures which result from emulating=
=0D
> > task switch for an L2-Guest results in being reported to userspace.=0D
> > =0D
> > Without this patch a malicious L2-Guest would be able to kill the L1 by=
 =0D
> > triggering a race-condition between an vmexit and the task switch emula=
tor.=0D
> =0D
> Only if L1 doesn't intercept task switches, which is only possible on SVM=
 (they=0D
> are a mandatory intercept on VMX).  If L1 is deferring task switch emulat=
ion to=0D
> L0, then IMO L0 is well within its rights to exit to userspace if KVM can=
't=0D
> emulate the task switch.=0D
> =0D
> So unless I'm missing something, I vote to keep the code as-is.=0D
> =0D
> > This patch is smiliar to commit fc3a9157d314 ("KVM: X86: Don't report L=
2 =0D
> > emulation failures to user-space")=0D
> =0D
> Generic emulation is different.  There are legitimate scenarios where KVM=
 needs=0D
> to emulate L2 instructions, without L1's explicit consent, and so KVM nee=
ds to=0D
> guard against L2 playing games with its code stream.=0D
> =0D
> Task switches are very different.  KVM doesn't fetch from the code stream=
, i.e.=0D
> L2 can't play TLB games, and I highly doubt there is a real world hypervi=
sor=0D
> that doesn't intercept task switches.=0D
=0D
Thank you for clarifying! Your explanation about this function makes sense.=
=0D
I agree there's no vulnerability here, and the existing code is justified.=
=0D
Appreciate the thorough review!=0D
=0D
> > Fixes: 1051778f6e1e ("KVM: x86: Handle emulation failure directly in kv=
m_task_switch()")=0D
> > =0D
> > Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>=0D
> > ---=0D
> >  arch/x86/kvm/x86.c | 8 +++++---=0D
> >  1 file changed, 5 insertions(+), 3 deletions(-)=0D
> > =0D
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c=0D
> > index 3712dde0bf9d..b22be88196ed 100644=0D
> > --- a/arch/x86/kvm/x86.c=0D
> > +++ b/arch/x86/kvm/x86.c=0D
> > @@ -11874,9 +11874,11 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16=
 tss_selector, int idt_index,=0D
> >  	 */=0D
> >  	if (ret || vcpu->mmio_needed) {=0D
> >  		vcpu->mmio_needed =3D false;=0D
> > -		vcpu->run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;=0D
> > -		vcpu->run->internal.suberror =3D KVM_INTERNAL_ERROR_EMULATION;=0D
> > -		vcpu->run->internal.ndata =3D 0;=0D
> > +		if (!is_guest_mode(vcpu)) {=0D
> > +			vcpu->run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;=0D
> > +			vcpu->run->internal.suberror =3D KVM_INTERNAL_ERROR_EMULATION;=0D
> > +			vcpu->run->internal.ndata =3D 0;=0D
> > +		}=0D
> >  		return 0;=0D
> >  	}=0D
> >  =0D
> > -- =0D
> > 2.34.1=0D
> > =0D
=0D
--=0D
Thanks, =0D
=0D
Chen Yufeng=


