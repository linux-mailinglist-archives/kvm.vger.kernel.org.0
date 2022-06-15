Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C06554D38C
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 23:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349978AbiFOVTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 17:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346316AbiFOVTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 17:19:38 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF215548E
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 14:19:36 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h192so12516666pgc.4
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 14:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fY3K+QuVtTnnSBwqWz3O8cnU+eO+gOnLV9alsVozetQ=;
        b=U8PLF2TJJN0V81R6+cDoGWQHeIt8g1tz4ErT5UXecoHHEQae5hinl/dbhUyX3GxCi7
         X3Llfc6c3vY5uKR1HOafm/Del5raE+bUJIhBebnwSJrHR3FMzK+P4DyEWIAX6j+D6Bi/
         zd2NV2vxCZnfcNP+9GokpEEtFbpTq0tSzGoXk//Sdexpn6g3ezh2+utZVYwKkTinwS+K
         XcfL9phFbiKpuyAJFld89sPPwH9t1j3I3q6LZUHzOLDTWvC2TP3GyDVEMhIs5YapANsZ
         eFFKzCKQokn17C84EEOr30FhRWJ0VvyOfPrX3rdrJj7KmyGpGHqAMEP4IVAasKKzMUKd
         +DUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fY3K+QuVtTnnSBwqWz3O8cnU+eO+gOnLV9alsVozetQ=;
        b=ytGCAWgx+lWHNrxYLjqu1sgvl8ijIG1GOcYtgAMk2uPVfKTk+SD6CPdJ+vOY6Lb1+k
         ndBM7DyJ1pMk4p10ePTJHvPpNdJe7BJi0D236nYigq7PJAfdZHpNLyNeNrRADZ3nJlGS
         YnANH8ZiOLgnfvMmA0QZQ3a+pDeBB/aX6vSiTVV8rGmhCbrGYTavMocTMRuK79O181+q
         /l8dYr0qiwb+0wgCK7VxPdKNamB114AkaKLwtGv3Z4MuZyNnbdOK/Q3wsYVr6ZriVdT2
         aZcluRmVqLpS+n//QwbB7WSUB2anbvqWFr+JrGyY0iJEpTGvluI1fdxD90U7KuuGD20B
         r3vQ==
X-Gm-Message-State: AJIora+mY+DSVldYA5Tf7gAObpmA7Taq+d5uFewyWv5XsIk9S6UoQOR/
        0KTHC6ydm+hbifBp6qYjprOFHsXjgwccQQ==
X-Google-Smtp-Source: AGRyM1vdTuZ9Ix+jCSnK+IKrh19vSqq3wf1EOQ9sAjhVwMvlJDXjME5ovBKQ/P3ImQZ5wNJexkxYMg==
X-Received: by 2002:a63:3c3:0:b0:3fc:5864:7412 with SMTP id 186-20020a6303c3000000b003fc58647412mr1523921pgd.138.1655327976038;
        Wed, 15 Jun 2022 14:19:36 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id w62-20020a627b41000000b005187431876fsm72391pfc.180.2022.06.15.14.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 14:19:35 -0700 (PDT)
Date:   Wed, 15 Jun 2022 21:19:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 00/11] SMP Support for x86 UEFI Tests
Message-ID: <YqpM5O8+dRNzKlZK@google.com>
References: <20220426114352.1262-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426114352.1262-1-varad.gautam@suse.com>
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

On Tue, Apr 26, 2022, Varad Gautam wrote:
> This series brings multi-vcpu support to UEFI tests on x86.
> 
> Most of the necessary AP bringup code already exists within kvm-unit-tests'
> cstart64.S, and has now been either rewritten in C or moved to a common location
> to be shared between EFI and non-EFI test builds.
> 
> A call gate is used to transition from 16-bit to 32-bit mode, since EFI may
> not load the 32-bit entrypoint low enough to be reachable from the SIPI vector.
> 
> Changes in v3:
> - Unbreak i386 build, ingest seanjc's reviews from v2.

I have more comments for this version, but if it's ok with you, I'll do the fixup
myself and send v4.  I'd like to my opinionated renames, e.g. ap_init() => bringup_aps(),
as part of this series instead of having to wait for this to get merged.
