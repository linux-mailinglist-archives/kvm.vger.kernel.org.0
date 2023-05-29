Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C793B714A87
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 15:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjE2Nob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 09:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjE2No3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 09:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0832C8E
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 06:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685367827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cVoBaxeWw0cSFEAA+V8+hZkU/IQSxLca/3oeriUuVyU=;
        b=iD0jOnM0RkI894pRXdwJ77XF9s/tgC7zZtZaq6P7KI+osPj9rxo6k/CJt6vbwC+RZ3HKJD
        EnMCHbw7HVtc7dg4dNIYTg3M8Rzbt9R2cpIC1BnKQjI77pqXAUWPIt6B59Idy7iXorl1f5
        RMuPKVRCOLnTYrKbTjpmTgO25RLd3Vs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-bxakOVjRNle_wvarOS6W1A-1; Mon, 29 May 2023 09:43:45 -0400
X-MC-Unique: bxakOVjRNle_wvarOS6W1A-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f60fb7b31fso12333195e9.2
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 06:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685367824; x=1687959824;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cVoBaxeWw0cSFEAA+V8+hZkU/IQSxLca/3oeriUuVyU=;
        b=N+I5/nVl7LHvvS7EXZab3teKnG12lxtF2Lz1MtHMwCNK5v5cgKr00oRFaj0RAPC0aC
         WAcBkJ3ZJkUODWzC/GbLa8DNnhOf6b2XgPhc7Tu60fHPtxMPF2VB/gS63hJnjTLpOc9I
         haEhUI1VFLFRMol/l19cl52lxZqw51GWcrmXltB9nlIRy8X5SePdVxMaAYZHxH++5VB6
         uckuf9VlMnL5GkhNWvRVucX8KZoYX005YLcHQS3HIVWuI56YSBmNY+3PYxzTWiivovTa
         Bnl+fKOBKcxTgT/DzFCVzU+jTw51Bz5CXq7+pKzxpQHtPR0sc+QOiXojharykAEPxqhk
         EgKg==
X-Gm-Message-State: AC+VfDzRWkbKo3xeJS+D1/tkoKgCelFHXWLQn+Gew7ymEYJ3dANg04Fl
        erLYH/f1ZOHqsuBH/Pp/iaDkMOy6QoLWwQ0jBLD8V/vV5Uu+05mx6aRuEkLtvzo47rNGMxdvZ6m
        FQRstntgAe4KRZ4YzV2Dl
X-Received: by 2002:a05:600c:249:b0:3f6:8af:414 with SMTP id 9-20020a05600c024900b003f608af0414mr10368932wmj.30.1685367824316;
        Mon, 29 May 2023 06:43:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7nPK6PHZe+BvdnFXg9GCe6fFlQqcQlngZ/w0VCsiF/+TTjh5jsSKQA6qVTkAiG5WNZ1mWG3Q==
X-Received: by 2002:a05:600c:249:b0:3f6:8af:414 with SMTP id 9-20020a05600c024900b003f608af0414mr10368922wmj.30.1685367823998;
        Mon, 29 May 2023 06:43:43 -0700 (PDT)
Received: from starship ([89.237.102.231])
        by smtp.gmail.com with ESMTPSA id f8-20020a1c6a08000000b003f41bb52834sm18083455wmc.38.2023.05.29.06.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 06:43:43 -0700 (PDT)
Message-ID: <357d135f9ed65f4e2970c82ae4e855547db70ad1.camel@redhat.com>
Subject: Re: [Bug] AMD nested: commit broke VMware
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     jwarren@tutanota.com, Kvm <kvm@vger.kernel.org>
Date:   Mon, 29 May 2023 16:43:41 +0300
In-Reply-To: <NWb_YOE--3-9@tutanota.com>
References: <NWb_YOE--3-9@tutanota.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У пн, 2023-05-29 у 14:58 +0200, jwarren@tutanota.com пише:
> Hello,
> Since kernel 5.16 users can't start VMware VMs when it is nested under KVM on AMD CPUs.
> 
> User reports are here:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2008583
> https://forums.unraid.net/topic/128868-vmware-7x-will-not-start-any-vms-under-unraid-6110/
> 
> I've pinpointed it to commit 174a921b6975ef959dd82ee9e8844067a62e3ec1 (appeared in 5.16rc1)
> "nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"
> 
> I've confirmed that VMware errors out when it checks for TLB_CONTROL_FLUSH_ASID support and gets a 'false' answer.
> 
> First revisions of the patch in question had some support for TLB_CONTROL_FLUSH_ASID, but it was removed:
> https://lore.kernel.org/kvm/f7c2d5f5-3560-8666-90be-3605220cb93c@redhat.com/
> 
> I don't know what would be the best case here, maybe put a quirk there, so it doesn't break "userspace".
> Committer's email is dead, so I'm writing here.
> 

I have to say that I know about this for long time, because some time ago I used  to play with VMware player in a 
VM on AMD on my spare time, on weekends 
(just doing various crazy things with double nesting, running win98 nested, vfio stuff, etc, etc).

I didn't report it because its a bug in VMWARE - they set a bit in the tlb_control without checking CPUID's FLUSHBYASID
which states that KVM doesn't support setting this bit.

Supporting FLUSHBYASID would fix this, and make nesting faster too, 
but it is far from a trivial job. 

I hope that I will find time to do this soon.

Best regards,
	Maxim Levitsky


