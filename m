Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E42C67E5D3
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbjA0MyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbjA0MyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:54:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC02677DEA
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 04:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674823997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rblz8inq6D48yAW7zzWriEh9NSWzJF/YAEfhSJOhdSo=;
        b=C0LEVKHKI/c01j4w9u0kYE0qMNifwwpicYoVf/Yzh3a4ZyAuaDgvDthFbX+qqkD5Y/6bMW
        Q5FiLTNKkzieidDJ0aVIaKgbQYhQ7S/DYM7OY8MF2hbshlMNi0mWd/BiIKuY0VUfbCkEaO
        RFJSdzQbKvDNMhBgSIlNYjtoSDnX1gI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-3-PfrCGybaOAOy8mZPLtfEGw-1; Fri, 27 Jan 2023 07:53:16 -0500
X-MC-Unique: PfrCGybaOAOy8mZPLtfEGw-1
Received: by mail-ej1-f71.google.com with SMTP id nd38-20020a17090762a600b00871ff52c6b5so3366323ejc.0
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 04:53:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rblz8inq6D48yAW7zzWriEh9NSWzJF/YAEfhSJOhdSo=;
        b=wdmpH2w0pMgrsGdW8/1kkIeDm/E13AlnYgOQFUlo1h26GVHi4DDUjdw6R5FBYvfF95
         pGGDkwADvluxhKw0QQ6+39y+Dq9Gl9WFwyjmOaFw/RtWPucZRzeZ4VW+PkFfYrbtKcE/
         xEWa57c/4jzLD8N4tg/ijZ/tt2VV8Bh4EKzdftxz299wgKhyj6G/IeyciPBpUoNNmIAQ
         +8EcP+zkyDajGu2HPwc926GBwVDhgZCmYevLJNjTrmNahJhjo6tGgOgr2tRAWz63ItdY
         bxE4Fe+SNZvms9KVMSToJYZVLin8GynhJx+/YesFY5pygwUYAGJftn9ePCmtfum1x79Q
         n//A==
X-Gm-Message-State: AFqh2krd/tvlFQHHBW3VcLI3mBmz/yZkBw4pzVwF+++fjgVw1yjr/AOn
        4Hcmkjq9LZCQkAH33MENU4NiG890f8i0R9WVnB+nfmiqLM/7W+rdwbXsqZRwXbqlME3VjIBYZHc
        tZ++FSLz0Rsx3
X-Received: by 2002:a17:906:314a:b0:870:2cc7:e8e2 with SMTP id e10-20020a170906314a00b008702cc7e8e2mr38944476eje.54.1674823995604;
        Fri, 27 Jan 2023 04:53:15 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt1pz6GUfvx7RgKCkC0SGE2rdGq45DXGioPsscWXJ841Jjdr9/L/8QaCf/JOD8dlKvCk5ktZg==
X-Received: by 2002:a17:906:314a:b0:870:2cc7:e8e2 with SMTP id e10-20020a170906314a00b008702cc7e8e2mr38944462eje.54.1674823995356;
        Fri, 27 Jan 2023 04:53:15 -0800 (PST)
Received: from redhat.com ([2.52.137.69])
        by smtp.gmail.com with ESMTPSA id o25-20020a170906861900b008675df83251sm2181030ejx.34.2023.01.27.04.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 04:53:14 -0800 (PST)
Date:   Fri, 27 Jan 2023 07:53:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        marcel.apfelbaum@gmail.com, imammedo@redhat.com,
        richard.henderson@linaro.org, yang.zhong@intel.com,
        jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
        wei.huang2@amd.com
Subject: Re: [PATCH v2 0/5] target/i386: Update AMD EPYC CPU Models
Message-ID: <20230127075149-mutt-send-email-mst@kernel.org>
References: <20230106185700.28744-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106185700.28744-1-babu.moger@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 06, 2023 at 12:56:55PM -0600, Babu Moger wrote:
> This series adds following changes.
> a. Allow versioned CPUs to specify new cache_info pointers.
> b. Add EPYC-v4, EPYC-Rome-v3 and EPYC-Milan-v2 fixing the
>    cache_info.complex_indexing.
> c. Introduce EPYC-Milan-v2 by adding few missing feature bits.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

who's merging this btw?
target/i386/cpu.c doesn't have an official maintainer in MAINTAINERS ...

> ---
> v2:
>   Refreshed the patches on top of latest master.
>   Changed the feature NULL_SELECT_CLEARS_BASE to NULL_SEL_CLR_BASE to
>   match the kernel name.
>   https://lore.kernel.org/kvm/20221205233235.622491-3-kim.phillips@amd.com/
> 
> v1: https://lore.kernel.org/kvm/167001034454.62456.7111414518087569436.stgit@bmoger-ubuntu/
> 
> 
> Babu Moger (3):
>   target/i386: Add a couple of feature bits in 8000_0008_EBX
>   target/i386: Add feature bits for CPUID_Fn80000021_EAX
>   target/i386: Add missing feature bits in EPYC-Milan model
> 
> Michael Roth (2):
>   target/i386: allow versioned CPUs to specify new cache_info
>   target/i386: Add new EPYC CPU versions with updated cache_info
> 
>  target/i386/cpu.c | 252 +++++++++++++++++++++++++++++++++++++++++++++-
>  target/i386/cpu.h |  12 +++
>  2 files changed, 259 insertions(+), 5 deletions(-)
> 
> -- 
> 2.34.1

