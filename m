Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9F65FBE80
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 01:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJKXrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 19:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJKXrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 19:47:18 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B453A50C1
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:47:10 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q10-20020a17090a304a00b0020b1d5f6975so470955pjl.0
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fuh4qop4UMDp8ZyQUueG7mURFaCM89/3M/PCM4KHlOg=;
        b=PzC3XCwZAq6xs8cUmec7+/ChlJSdUG5gxlh6n4ily7tMgujzBVqymjCuW5wpbyXw8x
         B0tf3E1QEtqNeIyDzNfKpkatQ7DJyjWI+0gqCTi7blpCSAyN34Y6x6rFXe6qGY44tfxd
         D9XB1ml7cFku/3VhaaMg0MtdPpDml73Y+NnrQ4E0vnxfbR7AjR22W/z/p0/oeH6TrgaC
         7HquUHeG2/x1hJYz1RNyWo+4AyGbrWXM3UDT13bXv4nGP+OVGTm0gD8oAvm+7XQPLG+B
         ISYDERfYl8hFZSEpObDxKh7YdPIpM73dckk+ak2c+p4J2HHuOKm34EeT8HNRwy2TeR6X
         jwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fuh4qop4UMDp8ZyQUueG7mURFaCM89/3M/PCM4KHlOg=;
        b=LaOZ0X/cbi+Au94f1L+dhUthS2tS81v95VVhAC6AX/wb5FR4CAJ+H5jANOkHH4lbLS
         AO5EgAeEoOodfCAyw+eA0o9vLp2RJW0S2AtvFvb3scyCprRKdlvC6F+viBrS6899Qh4R
         OrR56mUhHoJKym8k7fi50nWTPW9/ASsBBXNqVdX8LpF6YualNFZP4X+JfgSceuAL81HY
         L9wwFDuRMf3mQs6OpNJpC/+K5uuEFR94OqdVVyL8U5VuEsUyT9UWCYmKwJmLt+CCql9Q
         bBoihvVwjTp3eoSBzJ/rCsyHNv9gv1x+q+1/jXmegS7maZf/Xl3nyjYqTo/m0+KqRy1j
         t5hQ==
X-Gm-Message-State: ACrzQf3qOMoBTY80Q8sYXwk7xnixvtv/B+Cz48/hodLH5xKAsZjuMMuO
        vsJfYULVbLrLxH74xZj3Yam6qw==
X-Google-Smtp-Source: AMsMyM4GLzXlshfV6Wf4tzxfxP4FuZcm/K/bEgH2Rc7MP/w1vKEXY+mNJu6c6vTkgMtmmZ+w+I5rSQ==
X-Received: by 2002:a17:902:7043:b0:184:40e5:b5e7 with SMTP id h3-20020a170902704300b0018440e5b5e7mr2022989plt.98.1665532027312;
        Tue, 11 Oct 2022 16:47:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y14-20020aa79e0e000000b005623a138583sm9631317pfq.124.2022.10.11.16.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 16:47:06 -0700 (PDT)
Date:   Tue, 11 Oct 2022 23:47:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 1/3] KVM: selftests: implement random number
 generation for guest code
Message-ID: <Y0YAdQC7eP1TN90b@google.com>
References: <Y0W4dImhloev7Iaq@google.com>
 <gsnt8rlm2e38.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsnt8rlm2e38.fsf@coltonlewis-kvm.c.googlers.com>
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

On Tue, Oct 11, 2022, Colton Lewis wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > Regardless of whether or not the details are gory, having to be aware of
> > those details unnecessarily impedes understanding the code.  The vast, vast
> > majority of folks that read this code won't care about how PRNGs work.
> > Even if the reader is familiar with PRNGs, those details aren't at all
> > relevant to understanding what the guest code does.  The reader only needs
> > to know "oh, this is randomizing the address".  How the randomization works
> > is completely irrelevant for that level of understanding.
> 
> It is relevant if the reader of the guest code cares about reentrancy
> and thread-safety (good for such things as reproducing the same stream
> of randoms from the same initial conditions), because they will have to
> manage some state to make that work. Whether that state is an integer or
> an opaque struct requires the same level of knowledge to use the API.

By "readers" I'm not (only) talking about developers actively writing code, I'm
I'm talking about people that run this test, encounter a failure, and read the code
to try and understand what went wrong.  For those people, knowing that the guest is
generating a random number is sufficient information during initial triage.  If the
failure ends up being related to the random number, then yes they'll likely need to
learn the details, but that's a few steps down the road.

> > > I agree returning the value could make it easier to use as part of
> > > expressions, but is it that important?
> 
> > Yes, because in pretty much every use case, the random number is going to
> > be immediately consumed.  Readability and robustness aside, returning the
> > value cuts the amount of code need to generate and consume a random number
> > in half.
> 
> Ok. This is trivial to change (or implement on top of what is
> there). Would you be happy with something like the following?
> 
> uint32_t guest_random(uint32_t *seed)
> {
> 	*seed = (uint64_t)*seed * 48271 % ((uint32_t)(1 << 31) - 1);
> 	return *seed;
> }

Honestly, no.  I truly don't understand the pushback on throwing the seed into
a struct and giving the helpers more precise names.  E.g. without looking at the
prototype, guest_random() tells the reader nothing about the size of the random
number returned, whereas <namespace>_random_u32() or <namespace>_get_random_u32()
(if we want to more closely follow kernel nomenclature) tells the reader exactly
what is returned.

As a contrived example, imagine a bug where the intent was to do 50/50 reads/writes,
but the test ends up doing almost all writes.  Code that looks like:

	if (guest_random(...))

is less obviously wrong than

	if (guest_random_u32(...))

even if the user knows nothing about how the random number is generated.

And aside from hiding details and providing abstraction for readers, throwing a
shim struct around the seed means that if we do want to change up the internal
implementation, then we can do so without having to churn users.

The code is trivial to write and I can't think of any meaningful downside.  Worst
case scenario, we end up with an implementation that is slightly more formal than
then we really need.
