Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFDA64D454
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 01:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiLOAGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 19:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiLOAFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 19:05:37 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5197A6B99D
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 15:58:20 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so990807pjj.2
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 15:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sUfaXM3dB136Mt6MS/K7rnxB3y/WuhYej+hl6uxyURE=;
        b=DB0mxQKfov26eLFfE+PKfnqccLxdAaArEsMPbGtAtUXu3a6mlbJSuCEMg+nJJL74nC
         h3Gf6bI839QDqFKWMOQNSCd6gI/zul8ttUAlNfRJEMqS6LB1/U4NARRxbpM7z7NguiVo
         XhQfz0n2XSuVBEPVfCXsLjasRZoahw032mMJ3eoI4NzbcERMBDajGascpDq1rzM9JSK+
         hpDuHD/UfrEmGMAORWzFTIo6Wzk4cmhlq9jHzPmCSPxzKyuekvYBHeQ+kJN7kWil7SBE
         zaGeoKZMp3EICqhC9myDaTM0BWeFjx5P6B44DiX5IpCgtmc1AII998LaFeMIH4dxKBW8
         +aDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sUfaXM3dB136Mt6MS/K7rnxB3y/WuhYej+hl6uxyURE=;
        b=IOKGtg6cAtYNWMw+Rt18SPoQNUKfGtAaLY9oiY2SZQEfWti5vjA1LMUIzHNqstYNiE
         afuPNYZh+qwfNmwSiy+1qx4hEi6RaoCaQW3adEM0KDBvMFJTCvFin/yciVu7g7vTr4nX
         pP0wGOTUim3IyVKcwv01Laq1yTI+Mf2PI32WKFGRs6daaSN4Ij9kcRDALcBeDfHJbxAG
         4KM/OcGjMSyBmC+pQLLl+E5hCR7nncI6W/dJAlShifrGzymvtQis5/TDrLA1goSP6mZq
         0zbZkQGOovIaiOsvtKDDg39F0wPy2sdhwyBo8evtC2geEu5t4woLhz+gmwRkI9oK5PKC
         BmRA==
X-Gm-Message-State: ANoB5pnus3S7uLfSWxtxDv7hQ9IrPX4cIwpgeK/Eh3L5GKKCiWgLSNeH
        cF9UPpOi4/i0ZZnwEPgFvv/2uQ==
X-Google-Smtp-Source: AA0mqf5EXv3WZDZXeRoMLDr+4ueR9n45leC47Tdf0xYkwEpRdzLpfsZQUEr3hqUJArxIJEQFBxBlHQ==
X-Received: by 2002:a05:6a20:1718:b0:9d:b8e6:d8e5 with SMTP id bn24-20020a056a20171800b0009db8e6d8e5mr861244pzb.2.1671062295814;
        Wed, 14 Dec 2022 15:58:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z29-20020aa7991d000000b005748029bab8sm382944pff.156.2022.12.14.15.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:58:14 -0800 (PST)
Date:   Wed, 14 Dec 2022 23:58:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Jayaramappa, Srilakshmi" <sjayaram@akamai.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "suleiman@google.com" <suleiman@google.com>,
        "Hunt, Joshua" <johunt@akamai.com>
Subject: Re: KVM: x86: snapshotted TSC frequency causing time drifts in vms
Message-ID: <Y5pjEwsdeRXVtjcj@google.com>
References: <a49dfacc8a99424a94993171ba2955a0@akamai.com>
 <Y2BFSZ1ExLiOIIi9@google.com>
 <5394d31b6be148b49b80b33aaa39ff45@akamai.com>
 <46774ef6c59e45bf9b166ca4833dddd7@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46774ef6c59e45bf9b166ca4833dddd7@akamai.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022, Jayaramappa, Srilakshmi wrote:
> > There doesn't seem to be any response on the v6 of Anton's patch. I wanted to
> > ask if there is further changes in progress or if it is all set to be merged?
> 
> Drat, it slipped through the cracks.
> 
> Paolo, can you pick up the below patch?  Oobviously assuming you don't spy any
> problems.
> 
> It has a superficial conflict with commit 938c8745bcf2 ("KVM: x86: Introduce

...

> Could I trouble you to take a look at this patch please? 

It's already in kvm/next

  3ebcbd2244f5 ("KVM: x86: Use current rather than snapshotted TSC frequency if it is constant")

but there was a hiccup with the KVM pull request for 6.2[*], which is why it hasn't
made it's way to Linus yet.

[*] https://lore.kernel.org/all/6d96a62e-d5a1-e606-3bd2-c38f4a6c8545@redhat.com
