Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9DB4C340A
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiBXRvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiBXRvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 12:51:16 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7561C6670
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:50:46 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id s1so2408565plg.12
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vhKKmYtw9SaXOcf6Vm61pOGRR9SjgnfuDr4ZszyuH1g=;
        b=V2/30CJh3gAARgxkDKqdir6SuxF5FkwxCggMoOympO2DxRpr6R0+eCCQSRST3VuMAA
         UXdkOJbO9F99ygqXcBVn1lzWmfHxuKtviUskfMmjRpCjtFZbAFBBTL4Dxze0XLLiXE3z
         1YwqIbncHdbKH2jOmvPBRTVKP6NhMXVOVC8jF+jytta1PbEdn/5sxes/Qtl+UVcgDGfE
         BUoMGidlmqOqkXZEor0vKchR7Mo6gPqNQKTrzYdV4lpKZnrqvrW1hwips5dCuiV0Fm8W
         r1Q7KZXXBah40FCrZVAr9oXQcVWrpZBCc1EY+eKb41Yd59d+OJV0SU46gx2gvJ8+O3Ij
         2WDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vhKKmYtw9SaXOcf6Vm61pOGRR9SjgnfuDr4ZszyuH1g=;
        b=N5APe1KKR7bVbwujkqQqLNcoawqa2EzOtE2zq8tLdiiySAevvHnzLPyTKggQFleJqq
         sVUdJw0spJPyA6rICf6UwVR4ym/l8mzxqmf7q0sqOXplXC8RO+ueklZNm4IEGPqiDWvU
         yG9iRAWSW4uHtSf6G06SeZbgPHWfN8D++xsn26xga+2E/UDufYrhTTnM0o3FtuCtpzq1
         feHLP3cDtYu6g9VHwBWkfWA3uri9ii9ayHXrn3jdCPV6dl1lXsxuR0vB4jeL9S+AFDs7
         aFDR4EMrtDcjJeQMx693VJsJfy5wwVg1W431GkR0HD3bg8xm9JgAIkz+D/0djhWkfCSl
         AahQ==
X-Gm-Message-State: AOAM532wxV8PYesLsyxO4ntYUxPpyWzs1ppDLUVa5prHsnEKNIshO+dG
        vZ4r4FLNm540OQq5MTX0jxa9Wg==
X-Google-Smtp-Source: ABdhPJxgo1/EIT6OVLXXzTIAis9Z7qLpGO1epE04nsLzME4XY1pqGDJlaiVz4M+x/v6j3OhQOE/1cA==
X-Received: by 2002:a17:902:e949:b0:14b:1f32:e926 with SMTP id b9-20020a170902e94900b0014b1f32e926mr3753799pll.170.1645725046327;
        Thu, 24 Feb 2022 09:50:46 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g7-20020a056a000b8700b004e1bed5c3bfsm131956pfj.68.2022.02.24.09.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 09:50:45 -0800 (PST)
Date:   Thu, 24 Feb 2022 17:50:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fixes for kvm/queue
Message-ID: <YhfFcqeVzUoFlntf@google.com>
References: <20211216021938.11752-1-jiangshanlai@gmail.com>
 <7fc9348d-5bee-b5b6-4457-6bde1e749422@redhat.com>
 <CANRm+CyHfgOyxyk7KPzYR714dQaakPrVbwSf_cyvBMo+vQcmAw@mail.gmail.com>
 <YgaPZcET90k14fBa@google.com>
 <f9b5c079-ba10-b528-a2fc-efb40cbb5d8f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9b5c079-ba10-b528-a2fc-efb40cbb5d8f@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 11, 2022, Paolo Bonzini wrote:
> On 2/11/22 17:31, Sean Christopherson wrote:
> > > Maybe the patch "Revert "KVM: VMX: Save HOST_CR3 in
> > > vmx_prepare_switch_to_guest()"" is still missing in the latest
> > > kvm/queue, I saw the same warning.
> > 
> > It hasn't made it way to Linus either.
> 
> This was supposed to fix the buggy patch, too:
> 
>     commit a9f2705ec84449e3b8d70c804766f8e97e23080d
>     Author: Lai Jiangshan <laijs@linux.alibaba.com>
>     Date:   Thu Dec 16 10:19:36 2021 +0800
> 
>     KVM: VMX: Save HOST_CR3 in vmx_set_host_fs_gs()
>     The host CR3 in the vcpu thread can only be changed when scheduling,
>     so commit 15ad9762d69f ("KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()")
>     changed vmx.c to only save it in vmx_prepare_switch_to_guest().
>     However, it also has to be synced in vmx_sync_vmcs_host_state() when switching VMCS.
>     vmx_set_host_fs_gs() is called in both places, so rename it to
>     vmx_set_vmcs_host_state() and make it update HOST_CR3.
>     Fixes: 15ad9762d69f ("KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()")
>     Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>     Message-Id: <20211216021938.11752-2-jiangshanlai@gmail.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

The underlying premise that CR3 can change only when scheduling is wrong, reverts
incoming...
