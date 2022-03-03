Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860474CC7DD
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236480AbiCCVVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiCCVVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:21:35 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9B013687A
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 13:20:49 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id t19so2354476plr.5
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 13:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rBo3jZiOb9ie0OVzwiL7KeGDNnK38FfYtqhoqdr/oLw=;
        b=IJHZYEdssdmdMlb2+aXz7JQ31BYbsvxLjYn9LnFurux/4lGINeibeBYeYOLyvSYb6T
         43F49jU7r0OH9Dn2nbJXJiyr6bwUvbkoNuwsrrYEmU5SzoCFWWVkVnuEfrd1PoCQMDdr
         daQG9ZYuvKIbVaXwdtHq2W3ck+wtdheldhbx4u2bU3K/JvlZpKI4fy6c4Kaa68bdT93F
         anByzCC9lUmSFFeMhNhDq63ay0IY6H7Ea6QFR9XQGKtOWtkn+9qIM7uU1DGNGHQbnNxF
         jnNYlCpotrlOK8EaQU4y8l6ULSHiBb/SWtYyVkvTo8g9rBKmqktKAS3VLlFBSfQhha8x
         65Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rBo3jZiOb9ie0OVzwiL7KeGDNnK38FfYtqhoqdr/oLw=;
        b=xflEsmuuYwpRTmkqt2DVKC7Fp/vEAB3v1jFMGxT2E0uFicmNuBbyyfoTe2azMz7UKV
         lruJqTX6ia4NjRr9OQwZGwm32Y/8fPIw+C7xmTAN7EvedOfDF/AYRCT3aCetmnZhuUWy
         CAnlBzijgzXVrTN0qoKSvvlF18WhKY2/AjfXsj9bAI9wJ6hc8SGHS+z6oSq0BRBLXeKR
         H4a2rFqqD8sA1zuEJxztWHuU9KvgKyZr4MhT5yjvdHPJOnTgEMquF35LZOWn5uwQuoKr
         K817kdY87vbs6hBmh3rlpzj5aY3l7ZevnWM79nFjvYHAf96UCIIuevmlmSKYdB6DvGBI
         x/Nw==
X-Gm-Message-State: AOAM531/xuGL8nxnDIOgSdNA20oqKorWbb1cB0v2c9y7O4d9Pf8UpQQW
        rf7mNz1tlyOUvgUlUxZd8R827g==
X-Google-Smtp-Source: ABdhPJyZej1S+ipPlCpE5zwxhOct0Jzxus2BoBq3B7nKU4FQPqch3LAAJv5IuWcy80rDQRSInXeQGg==
X-Received: by 2002:a17:90a:1b81:b0:1be:ecf2:4cf8 with SMTP id w1-20020a17090a1b8100b001beecf24cf8mr7455284pjc.72.1646342448990;
        Thu, 03 Mar 2022 13:20:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o5-20020a655bc5000000b00372f7ecfcecsm2753439pgr.37.2022.03.03.13.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 13:20:47 -0800 (PST)
Date:   Thu, 3 Mar 2022 21:20:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 21/30] KVM: x86/mmu: Zap invalidated roots via
 asynchronous worker
Message-ID: <YiExLB3O2byI4Xdu@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-22-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303193842.370645-22-pbonzini@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> The only issue is that kvm_tdp_mmu_invalidate_all_roots() now assumes that
> there is at least one reference in kvm->users_count; so if the VM is dying
> just go through the slow path, as there is nothing to gain by using the fast
> zapping.

This isn't actually implemented. :-)
