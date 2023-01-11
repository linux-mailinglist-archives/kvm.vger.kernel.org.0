Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F52666670
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 23:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjAKWv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 17:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjAKWv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 17:51:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7631EEEE
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 14:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673477441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DNuRIx234xBK4R8VFIejMD9TSDy12orNNc1kRkpmlrg=;
        b=DakCX07gtdOnf50rYtJ7Bwh2hxho0u0CPRNXEoFijXx62liLy+U4aQSCnpqKuX5pApFCdv
        4ZfifAxotcW8nkQi3bGAV5dzaR57Klm5Nw6QBXT/Iwofkw1d/4ImxF2j2SM8ANa4tgr5R7
        3n0cljDJg75JBBwpe9NSNdM9FejebQM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-263-YxR6zeNeP5qlZmc7nWS8Ig-1; Wed, 11 Jan 2023 17:50:40 -0500
X-MC-Unique: YxR6zeNeP5qlZmc7nWS8Ig-1
Received: by mail-wm1-f70.google.com with SMTP id q19-20020a1cf313000000b003d96c95e2f9so3813617wmq.2
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 14:50:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DNuRIx234xBK4R8VFIejMD9TSDy12orNNc1kRkpmlrg=;
        b=eyJcQGms9ENCJ55IP4kqIN9HXkdYI3s2KQ86PfxOoW1+x2JACxJlGl4w62eWpa09Qd
         9CLT2Kaa5un7NmO2oqnt8kTW6t/rTbEiMgW9Ij1dICS7zHukDO5/eCF/sjTnHx+Sxfgk
         MVf4II2BfdxCZtbzErHmbnpNXyBiZ6EmUGkx0FGwt9LY+Lgy2KHgskaX6ZvMogI1p7lc
         KZkaefhzIzmb2jabUDpWkP/593eqUrFP9dAyYba/n2/juQ6Rg4ps58VW37Ht+1yQovQw
         e5tGF2Vb63Vdab1sLPIr9d6MUvED78O+MgKvgbQNnNTZ3tXvT0ncgK49kQVwkjRQY6wX
         0ACQ==
X-Gm-Message-State: AFqh2kro7WTSPfSijz27dZdexgyWjs8tLHuf/5ryFoeDBQcNqUDb2/O7
        TI9AUQVld3zIX76KjiRYdCmTkKF4X35o5vwUqCHVzX69jlSQPzfrrR0p2F8B7K8fa76j/urjzES
        CsD+riVYxv5sB
X-Received: by 2002:adf:eb4f:0:b0:242:659c:dc7 with SMTP id u15-20020adfeb4f000000b00242659c0dc7mr44773903wrn.61.1673477439618;
        Wed, 11 Jan 2023 14:50:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtCVGFTh+ebPPM3or9EavrIGXL6mCZV/ZRHwrKhvrHlNhtD/vpHdFcU1wZz5g/JwmiUrfQfRQ==
X-Received: by 2002:adf:eb4f:0:b0:242:659c:dc7 with SMTP id u15-20020adfeb4f000000b00242659c0dc7mr44773894wrn.61.1673477439385;
        Wed, 11 Jan 2023 14:50:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id w5-20020a05600018c500b002420dba6447sm14685325wrq.59.2023.01.11.14.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 14:50:38 -0800 (PST)
Message-ID: <2a420443-e45d-0334-0e72-dd40c4ee5b1e@redhat.com>
Date:   Wed, 11 Jan 2023 23:50:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
Content-Language: en-US
To:     Jiri Slaby <jirislaby@kernel.org>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>
Cc:     yuzhao@google.com, Michal Hocko <MHocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, shy828301@gmail.com
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/23 09:00, Jiri Slaby wrote:
> 
> 
> I rmmoded kvm-intel now, so:
>    qemu-kvm: failed to initialize kvm: No such file or directory
>    qemu-kvm: falling back to tcg
> and it behaves the same (more or less expected).

Not entirely expected, but at least it throws the ball to mm camp and 
excludes any bug involving KVM mmu notifiers.

Paolo

