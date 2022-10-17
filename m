Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAF66015ED
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiJQSFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiJQSFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:05:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C452552E48
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666029935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vF2sJeqK33WsJwhgwCfRKMDWgTW/4ftrca8DnXxxZ2M=;
        b=hzMK1ZaP66DwX/RUOFg+8tA5uE7B96nB5g1AejKrRzM9zkh0EJEY6jBdSi2CW/7fe+UWof
        517B8/2ADQtT+1fM+IpCZEIadVf7jP6Yrr85IctA6zJ0qoaD6ywLpA94CYbfhpIDlaIPhz
        kOYaIqLzIfIeOOwVx1XpK3E7T0aPxj8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-cGHLCvvoM4mhgUqrZQfyaw-1; Mon, 17 Oct 2022 14:05:31 -0400
X-MC-Unique: cGHLCvvoM4mhgUqrZQfyaw-1
Received: by mail-qv1-f69.google.com with SMTP id lz4-20020a0562145c4400b004b495b96748so6764230qvb.14
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:05:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vF2sJeqK33WsJwhgwCfRKMDWgTW/4ftrca8DnXxxZ2M=;
        b=3rGzHdeyzJDBqYZ2cuA046G3f8jiLhwMrzuVnNqdVLxOoyK2NIo9Xco1Y87PQtCmFO
         l+ah/WKvZNQqAbr9F5LqZwh4QhxjDL3bGarotMd6QfJj8lHDlo6h+J9MCKin1SFmdoeH
         h+J7MXw6O9Y8NWhizVzYLkvmr5ZacvAeSBtp+1BuDNCQYGpZH4cZl1HpgKN0UrE1NSV+
         hzPRcj4G75eSlFIDVjFRfRd6jBpuD98pEoegd8n7TPzWC5sKtPQbTysgNLn7look1rZc
         TFOjl3FJLgZwZtwgfrg9HJAWioyk5pDGXdPxSjOzj9kZQF/jjk6+vBPvFtoIapR81uFx
         CTIw==
X-Gm-Message-State: ACrzQf0C0PiHLKeGh7Do5L5FAf/KxNkOg7AJnAJmaEudI8gAE+A3/7bP
        ZjjE6a6hubOEajWKNdzRVhatDAdLlVscOT2/NFQQ5L4gtNoZd0MaLlbwNqryLi5737be2gHNFLW
        mhuZHNDDTJiDv
X-Received: by 2002:ac8:5712:0:b0:39c:cd48:25e4 with SMTP id 18-20020ac85712000000b0039ccd4825e4mr9992176qtw.581.1666029930687;
        Mon, 17 Oct 2022 11:05:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6v13ETi7WQxtjbfJxiZi3n2hqXB77q4ok2HffXpTCqHix03f7jC+/5+q6Iuh/ZG1uAP9siBg==
X-Received: by 2002:ac8:5712:0:b0:39c:cd48:25e4 with SMTP id 18-20020ac85712000000b0039ccd4825e4mr9992156qtw.581.1666029930457;
        Mon, 17 Oct 2022 11:05:30 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id u10-20020ac8750a000000b0039764587192sm281196qtq.57.2022.10.17.11.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 11:05:29 -0700 (PDT)
Date:   Mon, 17 Oct 2022 14:05:28 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: x86: Reduce refcount if single_open() fails
 in kvm_mmu_rmaps_stat_open()
Message-ID: <Y02ZaByd+O71o3Un@x1n>
References: <5ddb7c97d2f1edbd000020aa842b0619374e6951.1665975828.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5ddb7c97d2f1edbd000020aa842b0619374e6951.1665975828.git.houwenlong.hwl@antgroup.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022 at 11:06:09AM +0800, Hou Wenlong wrote:
> Refcount is increased before calling single_open() in
> kvm_mmu_rmaps_stat_open(), If single_open() fails, refcount should be
> restored, otherwise the vm couldn't be destroyed.
> 
> Fixes: 3bcd0662d66fd ("KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file")
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

