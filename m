Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D3C603035
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 17:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiJRPwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 11:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiJRPwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 11:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14242D57D4
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 08:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666108268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BoKkcuxL5NREz5vjMqNcHiKa9FwvH6HgAB/kBFDCW9w=;
        b=g/rhxnw/2kh8Kge3uMnNDqKfCpfX0B/mmIlKX4MVIpNu+9+/Gfnxw8X9R7bdDG2oj+PV7n
        aATi+QhrmHe0oT3Jf0r3nnmKpewVt/Nn9VfKfEhmwtcb1bzmRLGo4ajBmt8L7Ufx1/hzj+
        6thlgUrnNwpj8wHPDvSi7FyKlxCprUE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-261--ydRZS5xOpGbOyGlREN-bA-1; Tue, 18 Oct 2022 11:51:06 -0400
X-MC-Unique: -ydRZS5xOpGbOyGlREN-bA-1
Received: by mail-il1-f199.google.com with SMTP id z4-20020a921a44000000b002f8da436b83so12302514ill.19
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 08:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoKkcuxL5NREz5vjMqNcHiKa9FwvH6HgAB/kBFDCW9w=;
        b=sQYoO6zueUBGj9pGQZAJxc6LzxRk3m7sDuafeHOFM/RJClxnNe7qHuRr4Ge4borh0m
         Y4qUpntYH24I7PAxTb4+B6sn94wqD1zbXm7+NXEbb5hiOla3YSOSGKHg32RBSxWyBiQs
         mWhQtGhVZ0Zpgl/PKU1RiyZn8kPWRY4+hhkWj039gSdhfsDyy2gCOH0k5eu+Htr617Oq
         GoKEtTt3fhwl1V+irwR8CUIKBJg7bB7CTQeoXnRo0kJYaj9yIRwKdGFT+7lCwExUxS5D
         d8yLp4HEjIys1oG9RoIaa7JVxlOLRz7UQ6/iMJAjg1NImHvjM8EZCymykBTb9OLSjiBH
         p8Zg==
X-Gm-Message-State: ACrzQf36C8VeaHbMPxcXHP8X/s6S6oCxjFvfBsEktHB4mWQCpwSynFBh
        50i05IlV33BwqOFWELBgGHqiwdEWTed29M1XIXlVC0Lip0SjoQ+QZk6G2e1Ty7wkoKbV7Hm8Fua
        PFuoZohYSoWdH
X-Received: by 2002:a05:6638:1903:b0:363:e824:2193 with SMTP id p3-20020a056638190300b00363e8242193mr2260584jal.40.1666108264898;
        Tue, 18 Oct 2022 08:51:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7rTkkIhDBNg5wS6havwCc+dTDzEUFDvH98GZ+b7II2SM5/9WtuFcl6vpreWjVh7ZL84I5kVw==
X-Received: by 2002:a05:6638:1903:b0:363:e824:2193 with SMTP id p3-20020a056638190300b00363e8242193mr2260559jal.40.1666108264633;
        Tue, 18 Oct 2022 08:51:04 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id h39-20020a022b27000000b00363c866d646sm1188924jaa.26.2022.10.18.08.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 08:51:04 -0700 (PDT)
Date:   Tue, 18 Oct 2022 11:50:59 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        seanjc@google.com, shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y07LY41y6ZRL3d3S@x1n>
References: <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local>
 <Y0SxnoT5u7+1TCT+@google.com>
 <Y0S2zY4G7jBxVgpu@xz-m1.local>
 <Y0TDCxfVVme8uPGU@google.com>
 <Y0mUh5dEErRVtfjl@x1n>
 <Y05X4o1TxxkvES9E@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y05X4o1TxxkvES9E@google.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022 at 10:38:10AM +0300, Oliver Upton wrote:
> If we ever get to the point that we can relax this restriction i think a
> flag on the BITMAP_WITH_TABLE cap that says "I don't actually set any
> bits in the bitmap" would do. We shouldn't hide the cap entirely, as
> that would be ABI breakage for VMMs that expect bitmap+ring.

I'd rather drop the cap directly if it's just a boolean that tells us
"whether we need bitmap to back rings". Btw when I said "dropping it" I
meant "don't return 1 for the cap anymore" - we definitely need to make the
cap macro stable as part of kvm API..

But I think I misunderstood the proposal previously, sorry. I assumed we
were discussing an internal HAVE_DIRTY_RING_WITH_BITMAP only.  I noticed
this only after I had a closer look at Gavin's patch.  Having a cap exposed
sounds always good to me.

I'll comment on Gavin's patch directly, thanks.

-- 
Peter Xu

