Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B442F6F9D5F
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 03:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjEHBYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 May 2023 21:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjEHBX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 May 2023 21:23:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADBC12C
        for <kvm@vger.kernel.org>; Sun,  7 May 2023 18:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683508990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JWXgJrOi0veApt3CCm2dj5ggLRr24/6U5GIiI/IKSf8=;
        b=IbxZD9Pgj6jaVB4G6WOK6euftXO/9TMGFgBa3UJItueuPJ6m6YDWfB3XeuGZGXuDjteK/t
        HPnnWzsXZO+CXFR37L8KUzlcMboG7smFYdVqT6xtLEqNtghHt8+VAg9yhHWUpO54E1jZs/
        DzJ4iSmRZI52+ELYsG7EzzxPPsj/kWw=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-eVYHYkV9Osa0y_h0FeuQ4w-1; Sun, 07 May 2023 21:23:09 -0400
X-MC-Unique: eVYHYkV9Osa0y_h0FeuQ4w-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1ab1b24c7c9so5250255ad.0
        for <kvm@vger.kernel.org>; Sun, 07 May 2023 18:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683508983; x=1686100983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWXgJrOi0veApt3CCm2dj5ggLRr24/6U5GIiI/IKSf8=;
        b=NeW3DjR7pLoJMJBme5wA5L6Y+o6Q+ozow3FGlxLswJGkax+zQNd3sibx4WD5JQcaTw
         IANXTmmXm+eZp+oSmCKldjDAQSS7ETjNdhMyvZ7kvLLo8e/axyD+Yui/GFfWp+w9KE6k
         dWWVFY8fQc3l/4ZCsgQK6RmNSeMTNvD4IJCAkONkLNP1Nsqe6nIDikeSQ8Zxkp8Eg0Qq
         Q3cR46uwSio1hQ8hZcy7Z6XEmi6uOGvBZc9QV2Ol8k6XnFX2F2/xVedlNlf5cYNHO21M
         f9loZw7WiuR4xnx9KwhEyUJDEpVgKtDRDSkAWv6kEL1iieWqDGHfD0fITFvcsgfjsjNW
         kF1w==
X-Gm-Message-State: AC+VfDxqYieerE+AuTADvvxWUXZm+z9TEhQSdsm+yDjYsEJ1/XFs8gU7
        QFoHY849J+th2x5AaftuBd8TiNNm6VlU4QDcXLGt7pD1XRdsRBr0t3zMhJi518TPf1ccI4jrmb+
        SAbW57B0Z+Bf7
X-Received: by 2002:a17:903:2284:b0:1a9:4b42:a5a2 with SMTP id b4-20020a170903228400b001a94b42a5a2mr10671614plh.0.1683508983340;
        Sun, 07 May 2023 18:23:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4hHg5Eq2zP00CeLtDM4c3X7G5A0Ae2cCvdNjGap9qMh5qpRSIbSyIM/KwyakcW4TZE8f5Q/A==
X-Received: by 2002:a17:903:2284:b0:1a9:4b42:a5a2 with SMTP id b4-20020a170903228400b001a94b42a5a2mr10671588plh.0.1683508982912;
        Sun, 07 May 2023 18:23:02 -0700 (PDT)
Received: from x1n ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id n19-20020a170902969300b001aae625e422sm5796728plp.37.2023.05.07.18.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 18:23:02 -0700 (PDT)
Date:   Sun, 7 May 2023 21:23:01 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFhO9dlaFQRwaPFa@x1n>
References: <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n>
 <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
 <ZFQC5TZ9tVSvxFWt@x1n>
 <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05, 2023 at 11:32:11AM -0700, Anish Moorthy wrote:
> Peter, I'm afraid that isolating cores and splitting them into groups
> is new to me. Do you mind explaining exactly what you did here?

So far I think the most important pinning is the vcpu thread pinning, we
should test always with that in this case to avoid the vcpu load overhead
not scaling with cores/vcpus.

What I did was (1) isolate cores (using isolcpus=xxx), then (2) manually
pinning the userfault threads to some other isolated cores.  But maybe this
is not needed.

> 
> Also, I finally got some of my own perf traces for the self test: [1]
> shows what happens with 32 vCPUs faulting on a single uffd with 32
> reader threads, with the contention clearly being a huge issue, and
> [2] shows the effect of demand paging through memory faults on that
> configuration. Unfortunately the export-to-svg functionality on our
> internal tool seems broken, so I could only grab pngs :(
> 
> [1] https://drive.google.com/file/d/1YWiZTjb2FPmqj0tkbk4cuH0Oq8l65nsU/view?usp=drivesdk
> [2] https://drive.google.com/file/d/1P76_6SSAHpLxNgDAErSwRmXBLkuDeFoA/view?usp=drivesdk

Understood.  What I tested was without -a so it's using >1 uffds.

I explained why I think it could be useful to test this in my reply to
Nadav, do you think it makes sense to you?  e.g. compare (1) 32 vcpus + 32
uffd threads and (2) 64 vcpus + 64 uffd threads, again we need to make sure
vcpu threads are pinned using -c this time.  It'll be nice to pin the uffd
threads too but I'm not sure whether it'll make a huge difference.

Thanks,

-- 
Peter Xu

