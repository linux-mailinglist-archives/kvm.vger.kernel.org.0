Return-Path: <kvm+bounces-7961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8BD8493AD
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 07:05:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AAE36B22A98
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 06:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C95BE4C;
	Mon,  5 Feb 2024 06:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FLSdqkH8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A44107B6
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 06:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707113108; cv=none; b=MreOU/q9sqSrXt6w7kIRDunNLsmYU+PS3T3eQUSRRlvOSBLSfFNCKCuRtCQQKkOMlxFTlTgi22Jhw9Cpn4d45XzNxHUhqqrbnXpSXc2GDAB4z2eGjQGX21w5aPhzgtXe0d+fJgUNHAqeMILvMZtkxEsN/lOqmW89JZYAsWZsQ0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707113108; c=relaxed/simple;
	bh=E6VThuS6J+4wlEDuGxjEHe+5OXrQEnop+Am9LxEWQ5A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=DBFVpkrj+hKypSxmxEnfxKgCmcQfxifGGfR2byyC1xodGMdmJM63t2NzN4pliqMuuGFTHirnHB5/8T0l3wLC27v+If3iinamfIDRHtacAz0Q7uG3vv/buG9pE6qGT3pAsYUOi3CgapoimWeMtFZgXRkQlSy6gzvIVTM3LOaacWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FLSdqkH8; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a370328e8b8so325948166b.3
        for <kvm@vger.kernel.org>; Sun, 04 Feb 2024 22:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707113105; x=1707717905; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rUXcEjTVz3Gf2NIAf1nzsfebyGEbAOBm45S3k0v9MtE=;
        b=FLSdqkH81dxaDvZr0r8BBPDHiveU5ucnvLSA6Q2eh0iUOy8nJWl7MgSIjwj1BA5n5G
         ND5DUtEFzj/H8SH32BSs7Bi/zcHC7NAgIB2fOFjFMR9o5/KMUtopda36kxcJg93oZewz
         uZJTI2EldVp9NbzDTiMu0kJThw0AZBkBSloyjjb0iRO/7nR+tA/Fo8fGO4W7JQuuffQT
         UE5wTfGBHbvnRHbWbfugw3Ytkap2klCU+ZyYy0E7tDQqaUcd9bQHKDf3SMw7JfOt1DZf
         4tCzffjRfePHHz2DZ8yVipBmjxB10VUj5qr0AJzKmzYa3tZiSnQP7qi4WAzXQaGOCnV6
         CwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707113105; x=1707717905;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rUXcEjTVz3Gf2NIAf1nzsfebyGEbAOBm45S3k0v9MtE=;
        b=EKtBEYlVo9JlYqpxkv3G3ykWZifh2nCTu2wVw5+Hib2dphJvDVcnXYMe4QLCavpSlM
         hvwpHMYeQsoDj18ePo88kv4Amgk++pJludDEfSFeWqtH4yXKse5sdZM5TcWdpNC/P0dm
         yPr7p52X1nWdWtimqV8+xBGPORP2Qa6bHigfscVhy4b30prtNESOWp3RGqKzcU9M0xrO
         oJKzemuibspwCxKXRa8JSMFTUYuXLk5uNhJNk7nxJSFjukfmH4c4WLDoa59EndN01ofZ
         BXNYn+HJZVM46+NVdnraSNPz3Pz90UOrjtZhgp2uk3noD6Y5Y+Jo8qmy+u7HCJFS4LQb
         RVlw==
X-Gm-Message-State: AOJu0YxBNdTCzJoOCW7oofo10+VpX/58XPkzDnnMiL06g55g69do7FPF
	6gE71jlsXJb6SMz/OvRq60aYqDuP71CvSCNik2lRROFu5y09gfeDD/QTUgQofKE=
X-Google-Smtp-Source: AGHT+IFssy5CqM/Vb883XVIq5x8aJyEs2QxpbCyIySIjv0SV1nfr8XHJmThxvy0aeOQuPNaZjqe8yQ==
X-Received: by 2002:a17:906:1445:b0:a30:e4d8:2e46 with SMTP id q5-20020a170906144500b00a30e4d82e46mr6276594ejc.20.1707113104474;
        Sun, 04 Feb 2024 22:05:04 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCX0flFMNydgt2mx5eZkyzjut6uqV1WnMHvISyxJQDUv0vo4E6xj5/Akl0Dc+n3DdN//LFKXWjIqWXTb+cGtAMi/5dL3AIWjmU8lthqQ5NdD3fDgOZ9rdctSSRGTimbInUVqQXQjtpRTLCqaRy7htR+k2QD9h2ObBKZi7Hinb6sR3LFaD4p6qoPLXcvgJ/7WjbhBM2yLDpvYmbGCZk0WfqCEEu2vEnQTSKK3JvOI1eZ5bGofaV42e6R/u1C5ZaHlrGQ+zEnK4APuUDvLpIj4mXBy/EHfrtZX1mt36LxO+xhXjfRxB2pdFdF4y9Hy+yNvW9RiPW3q/E2eGqPJ2DWSoEEzjdCvk63QjwiR8YwDLHn0XZMvaKuYEExB8AaIehqhCgnP9PeKAFpiwP4Nvg==
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id pw8-20020a17090720a800b00a349d05c837sm3890430ejb.154.2024.02.04.22.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Feb 2024 22:05:03 -0800 (PST)
Date: Mon, 5 Feb 2024 09:05:00 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 01/15] KVM: arm64: vgic: Store LPIs in an xarray
Message-ID: <cd13d888-0d26-4dcc-b6a9-6a72e4e9d580@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124204909.105952-2-oliver.upton@linux.dev>

Hi Oliver,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Upton/KVM-arm64-vgic-Store-LPIs-in-an-xarray/20240125-045255
base:   6613476e225e090cc9aad49be7fa504e290dd33d
patch link:    https://lore.kernel.org/r/20240124204909.105952-2-oliver.upton%40linux.dev
patch subject: [PATCH 01/15] KVM: arm64: vgic: Store LPIs in an xarray
config: arm64-randconfig-r081-20240129 (https://download.01.org/0day-ci/archive/20240204/202402041412.mZlOxFFw-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 4a39d08908942b2d415db405844cbe4af73e75d4)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202402041412.mZlOxFFw-lkp@intel.com/

New smatch warnings:
arch/arm64/kvm/vgic/vgic-its.c:128 vgic_add_lpi() warn: inconsistent returns '&dist->lpi_list_lock'.
arch/arm64/kvm/vgic/vgic-its.c:128 vgic_add_lpi() warn: inconsistent returns 'flags'.

Old smatch warnings:
arch/arm64/kvm/vgic/vgic-its.c:324 update_lpi_config() warn: inconsistent returns '&irq->irq_lock'.
arch/arm64/kvm/vgic/vgic-its.c:324 update_lpi_config() warn: inconsistent returns 'flags'.

vim +128 arch/arm64/kvm/vgic/vgic-its.c

06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04   39  static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04   40  				     struct kvm_vcpu *vcpu)
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   41  {
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   42  	struct vgic_dist *dist = &kvm->arch.vgic;
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   43  	struct vgic_irq *irq = vgic_get_irq(kvm, NULL, intid), *oldirq;
388d4359680b56 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2018-05-11   44  	unsigned long flags;
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04   45  	int ret;
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   46  
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   47  	/* In this case there is no put, since we keep the reference. */
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   48  	if (irq)
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   49  		return irq;
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   50  
3ef231670b9e90 arch/arm64/kvm/vgic/vgic-its.c Jia He           2021-09-07   51  	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL_ACCOUNT);
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   52  	if (!irq)
99e5e886a0a59d virt/kvm/arm/vgic/vgic-its.c   Christoffer Dall 2016-08-01   53  		return ERR_PTR(-ENOMEM);
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   54  
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   55  	ret = xa_reserve_irq(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   56  	if (ret) {
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   57  		kfree(irq);
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   58  		return ERR_PTR(ret);
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   59  	}
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   60  
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   61  	INIT_LIST_HEAD(&irq->lpi_list);
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   62  	INIT_LIST_HEAD(&irq->ap_list);
8fa3adb8c6beee virt/kvm/arm/vgic/vgic-its.c   Julien Thierry   2019-01-07   63  	raw_spin_lock_init(&irq->irq_lock);
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   64  
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   65  	irq->config = VGIC_CONFIG_EDGE;
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   66  	kref_init(&irq->refcount);
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   67  	irq->intid = intid;
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04   68  	irq->target_vcpu = vcpu;
8df3c8f33f46ad virt/kvm/arm/vgic/vgic-its.c   Christoffer Dall 2018-07-16   69  	irq->group = 1;
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   70  
fc3bc475231e12 virt/kvm/arm/vgic/vgic-its.c   Julien Thierry   2019-01-07   71  	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   72  
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   73  	/*
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   74  	 * There could be a race with another vgic_add_lpi(), so we need to
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   75  	 * check that we don't add a second list entry with the same LPI.
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   76  	 */
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   77  	list_for_each_entry(oldirq, &dist->lpi_list_head, lpi_list) {
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   78  		if (oldirq->intid != intid)
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   79  			continue;
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   80  
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   81  		/* Someone was faster with adding this LPI, lets use that. */
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   82  		kfree(irq);
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   83  		irq = oldirq;
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   84  
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   85  		/*
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   86  		 * This increases the refcount, the caller is expected to
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   87  		 * call vgic_put_irq() on the returned pointer once it's
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   88  		 * finished with the IRQ.
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   89  		 */
d97594e6bc1b4a virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier     2016-07-17   90  		vgic_get_irq_kref(irq);
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   91  
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   92  		goto out_unlock;
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   93  	}
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15   94  
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   95  	ret = xa_err(xa_store(&dist->lpi_xa, intid, irq, 0));
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   96  	if (ret) {
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   97  		xa_release(&dist->lpi_xa, intid);
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   98  		kfree(irq);
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24   99  		return ERR_PTR(ret);

should be goto out_unlock or something

3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24  100  	}
3e55a25b7db23f arch/arm64/kvm/vgic/vgic-its.c Oliver Upton     2024-01-24  101  
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15  102  	list_add_tail(&irq->lpi_list, &dist->lpi_list_head);
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15  103  	dist->lpi_list_count++;
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15  104  
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15  105  out_unlock:
fc3bc475231e12 virt/kvm/arm/vgic/vgic-its.c   Julien Thierry   2019-01-07  106  	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15  107  
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04  108  	/*
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04  109  	 * We "cache" the configuration table entries in our struct vgic_irq's.
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04  110  	 * However we only have those structs for mapped IRQs, so we read in
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04  111  	 * the respective config data from memory here upon mapping the LPI.
57bdb436ce869a virt/kvm/arm/vgic/vgic-its.c   Zenghui Yu       2020-04-14  112  	 *
57bdb436ce869a virt/kvm/arm/vgic/vgic-its.c   Zenghui Yu       2020-04-14  113  	 * Should any of these fail, behave as if we couldn't create the LPI
57bdb436ce869a virt/kvm/arm/vgic/vgic-its.c   Zenghui Yu       2020-04-14  114  	 * by dropping the refcount and returning the error.
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04  115  	 */
6ce18e3a5f3308 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier     2017-10-27  116  	ret = update_lpi_config(kvm, irq, NULL, false);
57bdb436ce869a virt/kvm/arm/vgic/vgic-its.c   Zenghui Yu       2020-04-14  117  	if (ret) {
57bdb436ce869a virt/kvm/arm/vgic/vgic-its.c   Zenghui Yu       2020-04-14  118  		vgic_put_irq(kvm, irq);
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04  119  		return ERR_PTR(ret);
57bdb436ce869a virt/kvm/arm/vgic/vgic-its.c   Zenghui Yu       2020-04-14  120  	}
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04  121  
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04  122  	ret = vgic_v3_lpi_sync_pending_status(kvm, irq);
57bdb436ce869a virt/kvm/arm/vgic/vgic-its.c   Zenghui Yu       2020-04-14  123  	if (ret) {
57bdb436ce869a virt/kvm/arm/vgic/vgic-its.c   Zenghui Yu       2020-04-14  124  		vgic_put_irq(kvm, irq);
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04  125  		return ERR_PTR(ret);
57bdb436ce869a virt/kvm/arm/vgic/vgic-its.c   Zenghui Yu       2020-04-14  126  	}
06bd5359549d7a virt/kvm/arm/vgic/vgic-its.c   Eric Auger       2017-05-04  127  
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15 @128  	return irq;
df9f58fbea9bc6 virt/kvm/arm/vgic/vgic-its.c   Andre Przywara   2016-07-15  129  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


