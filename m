Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574AD706B92
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 16:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjEQOuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 10:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbjEQOu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 10:50:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32673C0C
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 07:50:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-51b67183546so549811a12.0
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 07:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684335028; x=1686927028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pDsdBMwmB7I2Qp688+UBcj3KD8alKjVIKuHiZri9HMU=;
        b=Vf+7S2HoSpfs2i91kZKs1dMajBCg4atRbZ1RdHfApDlXNjHAhHxRwez5A5qZNHe2jv
         V0o4IUUnS336MnI4yymhfCjVauEsGe8mKhzMo8rb46v3D64L7OyYpQlYBvNELH3PaE7V
         FcnaP5aDFfMfOWo+P5kJmjS+zZS//6/Lt34MqwTss3nyMeKmrbr/uI1dWi2bjbV1Ndkb
         cXCzjRfg6Nl1KV49v8ID5U6rveTZCkiD26mW7/h36IwbzqwvRsQvuzCVGjs+Ty2qNsgc
         EckxMnZV0hHOddy4Jc7+/6qYUYqXK1JZAUlL8AN2bGd8+Yo9N1QiKq7D6OW3Ya6pVVVF
         89AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684335028; x=1686927028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pDsdBMwmB7I2Qp688+UBcj3KD8alKjVIKuHiZri9HMU=;
        b=jpxYms+ScWfB/ygBmn+HE0/104czwpgcvyi0UdJiyoA5I6fYXtrg+kbhGC5JOqsmEt
         wzB3GRjpKNBS7Ca8V0ygBgmPoGQ52f/3URb331eQS+jBBmeztOL8HLnQEaXdLrjNSFVj
         f/G4QaZ1mCTHxloVymV9UiqfTzxMtlxHIHI2fjV+ffxjnUog+YHRDm+JG2qHW3acR3Hv
         uJp5e7tfsSXQ+Y6Jc+aDb+rdYPAcNJWaraOnVxApxZYbn3PyzrPyjV1LXZFQ5XkzyIqj
         tryHFdr9i9kUlhNItswii11tD3EygMb9KgIknp89ovw6VqGT1S2lzIO5Rk0afGYOr/X+
         N9FQ==
X-Gm-Message-State: AC+VfDzXpFSVTW5nMJfJNf/qrDTgzLPwS96+Cw48/lAVt+i82DAECDIl
        zYFC78eowpT6sLvZ1F/VtBLtxyoINTk=
X-Google-Smtp-Source: ACHHUZ75/t5JCGUIwclJmPSmeF9uOB4McX3h8rZmEZLvYDyHDz2kKHj8Q6kfck2kxY5E1pOs7Hb99X7Mh6A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6cc8:0:b0:52c:b46d:3609 with SMTP id
 h191-20020a636cc8000000b0052cb46d3609mr10657615pgc.12.1684335028469; Wed, 17
 May 2023 07:50:28 -0700 (PDT)
Date:   Wed, 17 May 2023 07:50:26 -0700
In-Reply-To: <ZGNO5gYKOhhnslsp@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com> <20230513003600.818142-4-seanjc@google.com>
 <ZGNO5gYKOhhnslsp@yzhao56-desk.sh.intel.com>
Message-ID: <ZGTpsvZed+r3Low1@google.com>
Subject: Re: [PATCH v3 03/28] drm/i915/gvt: Verify hugepages are contiguous in
 physical address space
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023, Yan Zhao wrote:
> hi Sean
> 
> Do you think it's necessary to double check that struct page pointers
> are also contiguous?

No, the virtual address space should be irrelevant.  The only way it would be
problematic is if something in dma_map_page() expected to be able to access the
entire chunk of memory by getting the virtual address of only the first page,
but I can't imagine that code is reading or writing memory, let alone doing so
across a huge range of memory.

> And do you like to also include a fix as below, which is to remove the
> warning in vfio_device_container_unpin_pages() when npage is 0?
> 
> @ -169,7 +173,8 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
>         *page = base_page;
>         return 0;
>  err:
> -       gvt_unpin_guest_page(vgpu, gfn, npage * PAGE_SIZE);
> +       if (npage)
> +               gvt_unpin_guest_page(vgpu, gfn, npage * PAGE_SIZE);
>         return ret;
>  }

Sure.  Want to give your SoB?  I'll write a changelog.

Thanks again!
