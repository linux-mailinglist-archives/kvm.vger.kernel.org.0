Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891FA60BF76
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 02:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiJYAWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 20:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiJYAVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 20:21:55 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDFE19E011
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 15:45:21 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q9-20020a17090a178900b00212fe7c6bbeso4315415pja.4
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 15:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IzIdWqwFLj5fY1F/cHydtWFars9saIw7viA8DOZalt0=;
        b=id/Shf2px0nm0w6YpRtcH83oau8NFtXtpVpRJhfStEnVAySUuwckkepCJhHxm++jTJ
         n023l4Kup9Ljld4UuM5WL2dtHuTMGMBIQcRhICrBPeiW8uWieqlZ49z5CXVorvviXfsN
         41OD4ajvLuE1MSbu4oW+LpZy7fXOPyiv9ZX8VqSFyKAztuuvotjpOn2qLfFfaDr8a2GN
         C6QDkzneR4VR34BC4gtwwb3rjnofH04ROA7i7f6gz05ofysJWeGFodBQyxb0rw/dmxCI
         I0JfWdevDb7YvoFs0KBEUzbm0IAEA1dXJH3ZyPgLikcbGAY3zmKMVBNnWk+hGhdkOb3v
         0KRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzIdWqwFLj5fY1F/cHydtWFars9saIw7viA8DOZalt0=;
        b=vYxRmtITZM6cP2aDTdRZXlpWfewHEJ8d9B/oxTVj/2El5S7xH+rIQtS4o9Q5a8wdCZ
         AWESSgwsN2vNCwOKdqnzD1RvpbHgghDUp8vj2KrstgbRieVcbbkqNq6fjq4YvLZO8IuB
         YOYN6xhg7r7oFDGnRVXnRYwANWjydRfo1APJvqA0S9Xf82WaSkwt8srJiCEFUtfJbwwb
         AfwJtbkjW8reCnEsZEHtRLBonfgPSV9eoni7DhTMbXqkleuTZv7Da+fbozfCSVzsDjuE
         pq9d47oGq6IrfFYSUT9i42iNmuwU7YpsPGihOnV9C/eHXiWO5MvYZNtxS8zbVeq68ozF
         42TA==
X-Gm-Message-State: ACrzQf3yBvK3sOZHZ3kn7Y8CeL2D9l70HhwU/iKV/hV7/BX5GejGC10K
        OfH1lh+wBnxunGjy6KllViVAYzMnub0erQ==
X-Google-Smtp-Source: AMsMyM4l/bCd7Zveoo+hni1dgz3W5uY9VEgosW/pOypYo8SEZWHh9AHRhyLQfyGd681OtJHgps7ddQ==
X-Received: by 2002:a17:902:b907:b0:178:2898:8084 with SMTP id bf7-20020a170902b90700b0017828988084mr34970711plb.140.1666651520768;
        Mon, 24 Oct 2022 15:45:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u14-20020a170903124e00b00177ff4019d9sm192701plh.274.2022.10.24.15.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 15:45:20 -0700 (PDT)
Date:   Mon, 24 Oct 2022 22:45:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: API to block and resume all running vcpus in a
 vm
Message-ID: <Y1cVfECAAfmp5XqA@google.com>
References: <20221022154819.1823133-1-eesposit@redhat.com>
 <a2e16531-5522-a334-40a1-2b0e17663800@linux.ibm.com>
 <2701ce67-bfff-8c0c-4450-7c4a281419de@redhat.com>
 <384b2622-8d7f-ce02-1452-84a86e3a5697@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <384b2622-8d7f-ce02-1452-84a86e3a5697@linux.ibm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022, Christian Borntraeger wrote:
> Am 24.10.22 um 10:33 schrieb Emanuele Giuseppe Esposito:
> > Am 24/10/2022 um 09:56 schrieb Christian Borntraeger:
> > > > Therefore the simplest solution is to pause all vcpus in the kvm
> > > > side, so that:

Simplest for QEMU maybe, most definitely not simplest for KVM.

> > > > - userspace just needs to call the new API before making memslots
> > > > changes, keeping modifications to the minimum
> > > > - dirty page updates are also performed when vcpus are blocked, so
> > > > there is no time window between the dirty page ioctl and memslots
> > > > modifications, since vcpus are all stopped.
> > > > - no need to modify the existing memslots API
> > > Isnt QEMU able to achieve the same goal today by forcing all vCPUs
> > > into userspace with a signal? Can you provide some rationale why this
> > > is better in the cover letter or patch description?
> > > 
> > David Hildenbrand tried to propose something similar here:
> > https://github.com/davidhildenbrand/qemu/commit/86b1bf546a8d00908e33f7362b0b61e2be8dbb7a
> > 
> > While it is not optimized, I think it's more complex that the current
> > serie, since qemu should also make sure all running ioctls finish and
> > prevent the new ones from getting executed.
> > 
> > Also we can't use pause_all_vcpus()/resume_all_vcpus() because they drop
> > the BQL.
> > 
> > Would that be ok as rationale?
> 
> Yes that helps and should be part of the cover letter for the next iterations.

But that doesn't explain why KVM needs to get involved, it only explains why QEMU
can't use its existing pause_all_vcpus().  I do not understand why this is a
problem QEMU needs KVM's help to solve.
