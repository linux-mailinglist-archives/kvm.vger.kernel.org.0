Return-Path: <kvm+bounces-22126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F0893A788
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 21:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B03E1F23269
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 19:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 003EE13D8A8;
	Tue, 23 Jul 2024 19:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f/BVdWVQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA80E13C3F5
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 19:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721761360; cv=none; b=EFw3fatMxhre6y7pkgd2KbiE1yZFnh805KYLhmboQr/kD//YKwRpF6+CHXPz3dUSlORxbBmIacp6bEb8RXpB3euE1HhhKzJ6VnFsrpYKoa3mlvUf29RKU/Zf2uUBmFp25KNfWqKbjFGJiEwpN8YhrOHeQy4G7BCYhmLFLjyOPxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721761360; c=relaxed/simple;
	bh=KwbQWb0MAhoY2OjQCdLmapJLpyIRCxaxJnxoHzmOdAg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NIJz2D9mB4ujrjU40WtHW6OIFPmgnbNTwoTi2Q6umOlEldgWkD/SUBgEtdBtjx1LFiCRi5vqSzBUjPohVfTuMmSdmgg+RYJ/g18hrACbVYlmKRCE53dbL730DVzCGHUtApQhfiBC3WgJU1XBLC/CuuwwQC46G2S1NECWoPnOukQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f/BVdWVQ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6818fa37eecso984762a12.1
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 12:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721761358; x=1722366158; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7lmlNmj12s8W5UsWp1IijSjTa58fODNO77ERHSHC9oE=;
        b=f/BVdWVQrxxEC/tPGNk/DC61eOveB5kuXIbhs9KxVQPCK7BgL7E4jJCDur8HR6dhhE
         xutLnmOJ+MbRjeh3xGaepxeUlfsGWJ5ySJYKZUm5Kb1VWTepvGX2NoDBbQlTHbjLtLYg
         pYFrmAH0SMYWBN+XSTJXY70nl5yCYUDlpaCTjI5M17T+TYVHlHdkTV3/zfq9xqDMmiun
         isYO7Wwl5wBbIPeERHLF0VbmFydrQoyhNFhJwhrU9/4M0Hd6yCsvozS1Jera43l4/jrP
         pHj4US2XhyDlkUCs3vB8tIW15j0OA3cO6MlUOdJw9tK+a1uV3hlB9LHURIfLLK2hji23
         OQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721761358; x=1722366158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7lmlNmj12s8W5UsWp1IijSjTa58fODNO77ERHSHC9oE=;
        b=v928Nj51e94iD5Kn+WeeZNm7pKZmztfhqTPoc9t6XrLB/HBRifcnVDDrBeOn33VE9o
         W3YS1Y+mwEw3iPEEZnslGRB56NRKsSVpQcRS1tH6XRr63eWfGFHPcLbZY/w8Q+2Ee2sx
         reroTh2JdHu4cqElpXgCGyiMrfo6WrXyu84bbgAe1QJltebIWyEGZ28FvZHqgrrbK28q
         XIb5DciEB00ECJSASUpq3IwV+JnvieGgp7nXBgIksECz/miYXgpoXScY8GS4LdawSc5z
         perTfBr2VKS3wWMwbid4bKQe+Xy4aQetMkLhvKmRN68pXw7Ah2EgmrDvJnqRyfiBot0a
         cggg==
X-Gm-Message-State: AOJu0YwO/u/AEOa4WELE3jQT1BgN6WjIyiB0ohFtGibnS5p2V7hdT3RV
	yLDRLTj6xceUJJ8Z+8phBm11TwPUzwIkBK7AqT46ZsnMunHwzVdyFz/z6zqLX/wLKfpvB3HiP6w
	VRw==
X-Google-Smtp-Source: AGHT+IHOPjL+9tt9AybGfCPZBKoFxw+NYvJCzMNFPlpt4srLlY7XUZD/iEdsfZZTGthXigKf55pSc5Sg450=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:374c:0:b0:6e5:62bf:f905 with SMTP id
 41be03b00d2f7-7a87fad1de9mr5a12.10.1721761357087; Tue, 23 Jul 2024 12:02:37
 -0700 (PDT)
Date: Tue, 23 Jul 2024 12:02:35 -0700
In-Reply-To: <d28f5bbb-14ce-455b-be75-a079f28eafa8@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <d28f5bbb-14ce-455b-be75-a079f28eafa8@stanley.mountain>
Message-ID: <Zp_-SzxSIqJKN3ay@google.com>
Subject: Re: [bug report] KVM: SVM: Set target pCPU during IRTE update if
 target vCPU is running
From: Sean Christopherson <seanjc@google.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kvm@vger.kernel.org, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="us-ascii"

+Suravee and Joerg

On Fri, Jul 19, 2024, Dan Carpenter wrote:
> Hello Sean Christopherson,
> 
> Commit f3cebc75e742 ("KVM: SVM: Set target pCPU during IRTE update if
> target vCPU is running") from Aug 8, 2023 (linux-next), leads to the
> following Smatch static checker warning:
> 
> 	arch/x86/kvm/svm/avic.c:841 svm_ir_list_add()
> 	error: we previously assumed 'pi->ir_data' could be null (see line 804)
> 
> arch/x86/kvm/svm/avic.c
>     792 static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
>     793 {
>     794         int ret = 0;
>     795         unsigned long flags;
>     796         struct amd_svm_iommu_ir *ir;
>     797         u64 entry;
>     798 
>     799         /**
>     800          * In some cases, the existing irte is updated and re-set,
>     801          * so we need to check here if it's already been * added
>     802          * to the ir_list.
>     803          */
>     804         if (pi->ir_data && (pi->prev_ga_tag != 0)) {
>                     ^^^^^^^^^^^
> The old code checks for NULL
> 
>     805                 struct kvm *kvm = svm->vcpu.kvm;
>     806                 u32 vcpu_id = AVIC_GATAG_TO_VCPUID(pi->prev_ga_tag);
>     807                 struct kvm_vcpu *prev_vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
>     808                 struct vcpu_svm *prev_svm;
>     809 
>     810                 if (!prev_vcpu) {
>     811                         ret = -EINVAL;
>     812                         goto out;
>     813                 }
>     814 
>     815                 prev_svm = to_svm(prev_vcpu);
>     816                 svm_ir_list_del(prev_svm, pi);
>     817         }
>     818 
>     819         /**
>     820          * Allocating new amd_iommu_pi_data, which will get
>     821          * add to the per-vcpu ir_list.
>     822          */
>     823         ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_KERNEL_ACCOUNT);
>     824         if (!ir) {
>     825                 ret = -ENOMEM;
>     826                 goto out;
>     827         }
>     828         ir->data = pi->ir_data;
>     829 
>     830         spin_lock_irqsave(&svm->ir_list_lock, flags);
>     831 
>     832         /*
>     833          * Update the target pCPU for IOMMU doorbells if the vCPU is running.
>     834          * If the vCPU is NOT running, i.e. is blocking or scheduled out, KVM
>     835          * will update the pCPU info when the vCPU awkened and/or scheduled in.
>     836          * See also avic_vcpu_load().
>     837          */
>     838         entry = READ_ONCE(*(svm->avic_physical_id_cache));
>     839         if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
>     840                 amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
> --> 841                                     true, pi->ir_data);
>                                                   ^^^^^^^^^^^
> The patch adds an unchecked dereference.  It could be a false positive if
> AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK implies that ->ir_data is non-NULL.  In
> that case could you just send an email saying "this is a false positive" and
> I'll ignore this warning going forward.

Hmm, yes and no.  AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK does kinda sorta gurantee
->ir_data is non-NULL, because avic_vcpu_load() will pass the same pointer to
amd_iommu_update_ga(), i.e. if ->ir_data is NULL, a crash would already have
happened.

However, I don't understand why _this_ code checks for a non-NULL pi->ir_data.
Or rather, I don't understand why that isn't considered a WARN-able failure.

Generally speaking, pi->ir_data is guaranteed to be valid, as the sole caller
checks that setting affinity succeeded:

			ret = irq_set_vcpu_affinity(host_irq, &pi);
			if (!ret && pi.is_guest_mode)
				svm_ir_list_add(svm, &pi);

but there is one path in amd_ir_set_vcpu_affinity() when it returns "success"
but doesn't set ir_data.

  static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
  {
	int ret;
	struct amd_iommu_pi_data *pi_data = vcpu_info;
	struct vcpu_data *vcpu_pi_info = pi_data->vcpu_data;
	struct amd_ir_data *ir_data = data->chip_data;
	struct irq_2_irte *irte_info = &ir_data->irq_2_irte;
	struct iommu_dev_data *dev_data;

	if (ir_data->iommu == NULL)
		return -EINVAL;

	dev_data = search_dev_data(ir_data->iommu, irte_info->devid);

	/* Note:
	 * This device has never been set up for guest mode.
	 * we should not modify the IRTE
	 */
	if (!dev_data || !dev_data->use_vapic) <===
		return 0;

	ir_data->cfg = irqd_cfg(data);
	pi_data->ir_data = ir_data;


That seems like it should be an error.  And then KVM should WARN if svm_ir_list_add()
is called with a NULL pi->ir_data.

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b19e8c0f48fa..e08d28f133d3 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3687,7 +3687,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
         * we should not modify the IRTE
         */
        if (!dev_data || !dev_data->use_vapic)
-               return 0;
+               return -EINVAL;
 
        ir_data->cfg = irqd_cfg(data);
        pi_data->ir_data = ir_data;

