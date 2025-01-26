Return-Path: <kvm+bounces-36605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E1AA1C76B
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 11:44:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FE2818861E4
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 10:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559751553BC;
	Sun, 26 Jan 2025 10:43:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EEF135A63;
	Sun, 26 Jan 2025 10:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737888238; cv=none; b=ZIfErzjf+H61pn8ErblKtP7P6qinkXtDN5bpeWmTPRLBNFupqVBGf0JsS366c13egfMqLWSTMVTtL9WUi8h9X8CrixXnLDS76OOhoIYvN7t+CRYd7V4H4NHXEZ1SaRSPCJF09TUlXu45RhvuHuUmrj0PGxpVWY+ONHaKOJ3pUPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737888238; c=relaxed/simple;
	bh=eMk8Vml2rd+ndaBkn8jpHGFaF+7vVFVRt362o45z07s=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=eZrSKwXjDPxIQl0dsfynaPyzGdCLsMMd8FSChou81G9xJ0uu8MNdSdtrOjgxACu58ciw+lxjpi2M5r2N+aTdg0Efp0iPPN5CWNTt+y3CuQOCymj/WaAmzDsH/gGKEw0dvIaxeGY74ZqFUXPBm79PUnw3e0vaQ8MP4JNfqx+xLRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy189.sjtu.edu.cn (smtp189.sjtu.edu.cn [202.120.2.189])
	by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 6D7EB7FCDB;
	Sun, 26 Jan 2025 18:33:40 +0800 (CST)
Received: from smtpclient.apple (unknown [101.80.151.229])
	by proxy189.sjtu.edu.cn (Postfix) with ESMTPSA id 4F9B83FC546;
	Sun, 26 Jan 2025 18:33:30 +0800 (CST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH v5 3/3] KVM: SVM: Flush cache only on CPUs running SEV
 guest
From: Zheyun Shen <szy0127@sjtu.edu.cn>
In-Reply-To: <85frlcvjyo.fsf@amd.com>
Date: Sun, 26 Jan 2025 18:33:12 +0800
Cc: thomas.lendacky@amd.com,
 seanjc@google.com,
 pbonzini@redhat.com,
 tglx@linutronix.de,
 kevinloughlin@google.com,
 mingo@redhat.com,
 bp@alien8.de,
 kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CB14B1BC-224D-4C10-969C-9C6C7E28F76B@sjtu.edu.cn>
References: <20250120120503.470533-1-szy0127@sjtu.edu.cn>
 <20250120120503.470533-4-szy0127@sjtu.edu.cn> <85frlcvjyo.fsf@amd.com>
To: Nikunj A Dadhania <nikunj@amd.com>
X-Mailer: Apple Mail (2.3826.200.121)



> Nikunj A Dadhania <nikunj@amd.com> writes=EF=BC=9A
>=20
> Zheyun Shen <szy0127@sjtu.edu.cn> writes:
>=20
>> On AMD CPUs without ensuring cache consistency, each memory page
>> reclamation in an SEV guest triggers a call to wbinvd_on_all_cpus(),
>> thereby affecting the performance of other programs on the host.
>>=20
>> Typically, an AMD server may have 128 cores or more, while the SEV =
guest
>> might only utilize 8 of these cores. Meanwhile, host can use =
qemu-affinity
>> to bind these 8 vCPUs to specific physical CPUs.
>>=20
>> Therefore, keeping a record of the physical core numbers each time a =
vCPU
>> runs can help avoid flushing the cache for all CPUs every time.
>>=20
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
>> ---
>> arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++++++++++++++++---
>> arch/x86/kvm/svm/svm.c |  2 ++
>> arch/x86/kvm/svm/svm.h |  5 ++++-
>> 3 files changed, 42 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 1ce67de9d..91469edd1 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -252,6 +252,36 @@ static void sev_asid_free(struct kvm_sev_info =
*sev)
>> 	sev->misc_cg =3D NULL;
>> }
>>=20
>> +static struct cpumask *sev_get_wbinvd_dirty_mask(struct kvm *kvm)
>> +{
>> +	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
>=20
> There is a helper to get sev_info: to_kvm_sev_info(), if you use that,
> sev_get_wbinvd_dirty_mask() helper will not be needed.
>=20
>> +
>> +	return sev->wbinvd_dirty_mask;
>> +}
>> +
>> +void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>> +{
>> +	/*
>> +	 * To optimize cache flushes when memory is reclaimed from an =
SEV VM,
>> +	 * track physical CPUs that enter the guest for SEV VMs and thus =
can
>> +	 * have encrypted, dirty data in the cache, and flush caches =
only for
>> +	 * CPUs that have entered the guest.
>> +	 */
>> +	cpumask_set_cpu(cpu, sev_get_wbinvd_dirty_mask(vcpu->kvm));
>> +}
>> +
>> +static void sev_do_wbinvd(struct kvm *kvm)
>> +{
>> +	struct cpumask *dirty_mask =3D sev_get_wbinvd_dirty_mask(kvm);
>> +
>> +	/*
>> +	 * TODO: Clear CPUs from the bitmap prior to flushing.  Doing so
>> +	 * requires serializing multiple calls and having CPUs mark =
themselves
>> +	 * "dirty" if they are currently running a vCPU for the VM.
>> +	 */
>> +	wbinvd_on_many_cpus(dirty_mask);
>> +}
>=20
> Something like the below
>=20
> void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> {
>        /* ... */
>        cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->wbinvd_dirty_mask);
> }
>=20
> static void sev_do_wbinvd(struct kvm *kvm)
> {
>        /* ... */
>        wbinvd_on_many_cpus(to_kvm_sev_info(kvm)->wbinvd_dirty_mask);
> }
>=20
> Regards,
> Nikunj
>=20
Got it, thanks.

Regards,
Zheyun Shen=

