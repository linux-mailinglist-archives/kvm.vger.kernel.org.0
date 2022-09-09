Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F23B5B3CB6
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 18:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiIIQLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 12:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiIIQLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 12:11:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10269EE9B5
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 09:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662739898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3V6tkMbDHWGuzpmv2iezKHnhh6C6Gq7prSLGElxdlvo=;
        b=LzmxSzrAdnMgEBFlkY3vagn9sOzllx5VIDaVIKgwezDR0fzitUTI4ZpcS4v0ZdLcUcdrEG
        vLVsEjPv960mjt6gJOjx6fliR1PjUL8SWfxLd6eDPOn9fSzgyRhEBe1X5ybNuxAMAwTRn4
        nbnZrtuN9WtdOnzXehmwtP0NTBX57kk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-5-_gWM5CpANbO8JYevXISKuw-1; Fri, 09 Sep 2022 12:11:29 -0400
X-MC-Unique: _gWM5CpANbO8JYevXISKuw-1
Received: by mail-qk1-f197.google.com with SMTP id w22-20020a05620a445600b006bb7f43d1cfso1828533qkp.16
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 09:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=3V6tkMbDHWGuzpmv2iezKHnhh6C6Gq7prSLGElxdlvo=;
        b=VC1aOvFPJySNC2XFiMORvLBWB96BqB7tlrEYcmnTaXusHqH/xNL0UqDH/hVYhva8Nd
         ZO5MN1aoPKy+Sh1OHBHKlSUECIcMCGToBE+JMLH2TYe2rSyeOL+FUSt3VcwtA5wxGpML
         i5hPYXqdE0p4c71Njf8ZHfKJqq4ioVae185pfHITqwoHZd3yfzKq726hTOaIsyNZMClZ
         D+QAVciPiyYnZ1OyylfMZ59A+wRi3i5K9C/yS4mnpetbxzvWdWJMB7d1vK+gQDnbHshj
         r7DjnBWdB9ljqBaFKXDvpizCn8gi+lsex1AG3nEb1rRHeBHJY/0dYB3CWN4TIM3HjmMZ
         a1Jw==
X-Gm-Message-State: ACgBeo3iAQ+8aWQd3DgiaWUXJV60JQfrd6CH08KPYBbPx+g3vXjQChOU
        41yaD+59L6BrcsCITk5fA30JOpSEmwGEuasT9/DlYfoSOEaEi7wH5yzG8RVuU3r3dcAuoHy45Ox
        yGZbpUPhUkrM2
X-Received: by 2002:ae9:efc9:0:b0:6cb:e321:12fb with SMTP id d192-20020ae9efc9000000b006cbe32112fbmr4471713qkg.446.1662739888729;
        Fri, 09 Sep 2022 09:11:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5I/ZBXZqE/p/fxuOPwWRewlB64ZKE33b/09QagZNajnZGs5vQ07ecFEBFyECMoWo6epJE49Q==
X-Received: by 2002:ae9:efc9:0:b0:6cb:e321:12fb with SMTP id d192-20020ae9efc9000000b006cbe32112fbmr4471665qkg.446.1662739888064;
        Fri, 09 Sep 2022 09:11:28 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id u22-20020a37ab16000000b006b633dc839esm693063qke.66.2022.09.09.09.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 09:11:27 -0700 (PDT)
Date:   Fri, 9 Sep 2022 12:11:26 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 2/3] i386: kvm: extend kvm_{get, put}_vcpu_events to
 support pending triple fault
Message-ID: <YxtlrnOYFwGTLHwL@xz-m1.local>
References: <20220817020845.21855-1-chenyi.qiang@intel.com>
 <20220817020845.21855-3-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220817020845.21855-3-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 10:08:44AM +0800, Chenyi Qiang wrote:
> For the direct triple faults, i.e. hardware detected and KVM morphed
> to VM-Exit, KVM will never lose them. But for triple faults sythesized
> by KVM, e.g. the RSM path, if KVM exits to userspace before the request
> is serviced, userspace could migrate the VM and lose the triple fault.
> 
> A new flag KVM_VCPUEVENT_VALID_TRIPLE_FAULT is defined to signal that
> the event.triple_fault_pending field contains a valid state if the
> KVM_CAP_X86_TRIPLE_FAULT_EVENT capability is enabled.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

