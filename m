Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C00F64747C
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiLHQlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiLHQlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:41:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0C25C0FA
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 08:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670517612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P1X+KFxP5lStihMWZu+vAKcvSQfQQhbIKpDUJ5DlVd4=;
        b=Ur2G4AIWI6sZ7L/U8thGAXM2nErK1/od/Ycy4JZdw8+i48X3+6VIt8RHW1V11BDW9gEHc0
        K0u3BdqRYNoNO+1fvXWfBMQH/JWrk2ph4RISckWzCWQ4RMPt+Ahl20SsfXH3zaE1apFdlW
        SdPUNKpuJm5SU7Dkkbin/t80sI+oNys=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-310-KwNaEIekORG-NZnfcAKUaA-1; Thu, 08 Dec 2022 11:40:11 -0500
X-MC-Unique: KwNaEIekORG-NZnfcAKUaA-1
Received: by mail-il1-f200.google.com with SMTP id 7-20020a056e0220c700b0030386f0d0e6so1784243ilq.3
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 08:40:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P1X+KFxP5lStihMWZu+vAKcvSQfQQhbIKpDUJ5DlVd4=;
        b=QQD/1HXL2SiyMOXm0rUFlvClo01dqwcNGcKA6MIzmkkRRQMz314q9/f1MLKiBpWVmI
         iaOs1sE4LmhRDl95FZeg4x05numYDa3sTJUktVkfV3adAxSxxYSB/dIBITRTi4YWp798
         mwU4RHOVQgLxrRCg2K7IYaP11Zs2kmdaV5Lloq5eZh4VZfbek1slrKb516X0+Rga1b8l
         ZbT8nazwwucxNAtl3FrEsOnCDgOkCpXoGz9ptuXJKiAjmYoyGlOukVhjg0Jy6nN0cI8N
         w2cMrWmwiT7k1bah8wZfpDj5L5vxkxjKZrFhDu/D7cKc4pVP9ygee5nmzd+0gdNeLYI0
         i5rA==
X-Gm-Message-State: ANoB5pkHh3rYTUToHcgRGaI7+q3aziFV9xixkyxTrioM2wFJyVifoqNJ
        dvA/iimo0PKupCogQ8SkEEBrLVEjm0FN3Ox+URb/eUSncFqep27BwGaqjTUcWF4bX/W5dkkHM84
        rHNrnIrPJ6JdA
X-Received: by 2002:a02:665f:0:b0:375:7ab5:7158 with SMTP id l31-20020a02665f000000b003757ab57158mr37694404jaf.160.1670517610744;
        Thu, 08 Dec 2022 08:40:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf62VQAfQty6YN1hlFnkq0P1eY9agOcHbE2epI0NKePHEV+gV3AglUh+0zZZkcK8BVZR92xL5g==
X-Received: by 2002:a02:665f:0:b0:375:7ab5:7158 with SMTP id l31-20020a02665f000000b003757ab57158mr37694402jaf.160.1670517610501;
        Thu, 08 Dec 2022 08:40:10 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p63-20020a022942000000b00389302c018bsm8887048jap.170.2022.12.08.08.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:40:09 -0800 (PST)
Date:   Thu, 8 Dec 2022 09:40:08 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "steven.sistare@oracle.com" <steven.sistare@oracle.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <20221208094008.1b79dd59.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <167044909523.3885870.619291306425395938.stgit@omen>
        <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Dec 2022 07:56:30 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, December 8, 2022 5:45 AM
> > 
> > Fix several loose ends relative to reverting support for vaddr removal
> > and update.  Mark feature and ioctl flags as deprecated, restore local
> > variable scope in pin pages, remove remaining support in the mapping
> > code.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> > This applies on top of Steve's patch[1] to fully remove and deprecate
> > this feature in the short term, following the same methodology we used
> > for the v1 migration interface removal.  The intention would be to pick
> > Steve's patch and this follow-on for v6.2 given that existing support
> > exposes vulnerabilities and no known upstream userspaces make use of
> > this feature.
> > 
> > [1]https://lore.kernel.org/all/1670363753-249738-2-git-send-email-
> > steven.sistare@oracle.com/
> >   
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> 
> btw given the exposure and no known upstream usage should this be
> also pushed to stable kernels?

I'll add to both:

Cc: stable@vger.kernel.org # v5.12+

Thanks,
Alex

