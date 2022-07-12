Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7278A572192
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 19:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiGLRJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 13:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiGLRJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 13:09:26 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8D522509
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 10:09:26 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id e16so7992833pfm.11
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 10:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2A19SFZc712Zr90/HxHXBLZXts62Gst8gLFaGLjAnSo=;
        b=VYS1kepNgU6dnPULTf1c3ax9LyR/C7eQbkjFEvadxbv9o9m6kfbFvC1BoeZS1b0LAV
         mbcpKkIgA2JX4BuPkUV/0ROYsqBHa8doX4iC3k2YuHrsA+o/DrJSDdlwBAYhQ8CYbLvf
         LftumPHX/MpRJsVLKHdPZhJchYT4iAmy3tC6e8vwK1eHycnlA01r2IloCJdoZSz3+taY
         Ek6jSpMuENPgYFC8OJpUsFH5a2HDPxxtP7qTXIVQEocYAbEPyVEP+TNsiP+lyBUdwWmk
         U44ZhQCRlc1LP8T6ZY6zPmIfp3BxaGEU6S449HEib+qJwAP57Cq9gtS4GcyWZlQLdjT+
         ZcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2A19SFZc712Zr90/HxHXBLZXts62Gst8gLFaGLjAnSo=;
        b=mH6D89buWJOefbSFb85ES7YEDUxbPcWF8TjTJ3/GTHNy5juKOsOboZU+fbICx5cVww
         6dz2VxI5/L7Gr3r+EfyKbjqOCAD1a77kz8K/XJX6tqfPHbyY/5ZmYc0Ue+nB+T/McYOx
         6rp5+3L+oKhGYkwwAQ/MTmWYJtkRuCqOEMnVcCMHD96xmNG24XSz7NW4ADP3JgVas1iC
         nhABi3b80Rf09nVvV9KQvOB8IE/aDnYyi8XYpzigxXbkP5vvNiq2da5RGohRb8OGvVeJ
         ttahWXqbmLcPYQkX6C0VU+D4mz7c8nDspyBYKFqf1+uykZlKEM+bIxWxJVhLKy0YSksE
         eNTg==
X-Gm-Message-State: AJIora+E6ehJhpq012i+uWFNuhnwIXOlC3DyNLSXGRkYsuj/Q9qlm6OJ
        9wxNXuf+Qtyf5md0/XjwtueCzw==
X-Google-Smtp-Source: AGRyM1uDTwQhRA0wYlzqevNp90NEff4OOswH9hUdtXRdhhORyeGNTBKDWZ2uoQOrknjumvz4R5sSXA==
X-Received: by 2002:a05:6a00:f85:b0:52a:c718:ff9 with SMTP id ct5-20020a056a000f8500b0052ac7180ff9mr14298591pfb.85.1657645765469;
        Tue, 12 Jul 2022 10:09:25 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b13-20020a170903228d00b0016c35b21901sm6745429plh.195.2022.07.12.10.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 10:09:24 -0700 (PDT)
Date:   Tue, 12 Jul 2022 17:09:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Add dedicated helper to get CPUID entry
 with significant index
Message-ID: <Ys2qwUmEJaJnsj6r@google.com>
References: <20220712000645.1144186-1-seanjc@google.com>
 <8a1ff7338f1252d75ff96c3518f16742919f92d7.camel@redhat.com>
 <Ys2i2B/jt5yDsAKj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ys2i2B/jt5yDsAKj@google.com>
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

On Tue, Jul 12, 2022, Sean Christopherson wrote:
> On Tue, Jul 12, 2022, Maxim Levitsky wrote:
> > On Tue, 2022-07-12 at 00:06 +0000, Sean Christopherson wrote:
> > > +               /*
> > > +                * Function matches and index is significant; not specifying an
> > > +                * exact index in this case is a KVM bug.
> > > +                */
> > Nitpick: Why KVM bug? Bad userspace can also provide a index-significant entry for cpuid
> > leaf for which index is not significant in the x86 spec.
> 
> Ugh, you're right.
> 
> > We could arrange a table of all known leaves and for each leaf if it has an index
> > in the x86 spec, and warn/reject the userspace CPUID info if it doesn't match.
> 
> We have such a table, cpuid_function_is_indexed().  The alternative would be to
> do:
> 
> 		WARN_ON_ONCE(index == KVM_CPUID_INDEX_NOT_SIGNIFICANT &&
> 			     cpuid_function_is_indexed(function));
> 
> The problem with rejecting userspace CPUID on mismatch is that it could break
> userspace :-/  Of course, this entire patch would also break userspace to some
> extent, e.g. if userspace is relying on an exact match on index==0.  The only
> difference being the guest lookups with an exact index would still work.
> 
> I think the restriction we could put in place would be that userspace can make
> a leaf more relaxed, e.g. to play nice if userspace forgets to set the SIGNFICANT
> flag, but rejects attempts to make guest CPUID more restrictive, i.e. disallow
> setting the SIGNFICANT flag on leafs that KVM doesn't enumerate as significant.
> 
> > > +               WARN_ON_ONCE(index == KVM_CPUID_INDEX_NOT_SIGNIFICANT);

Actually, better idea.  Let userspace do whatever, and have direct KVM lookups
for functions that architecturally don't have a significant index use the first
entry even if userspace set the SIGNIFICANT flag.  That will mostly maintain
backwards compatibility, the only thing that would break is if userspace set the
SIGNIFICANT flag _and_ provided a non-zero index _and_ relied on KVM to not match
the entry.

We could still enforce matching in the future, but it wouldn't be a prerequisite
for this cleanup.

		/*
		 * Similarly, use the first matching entry if KVM is doing a
		 * lookup (as opposed to emulating CPUID) for a function that's
		 * architecturally defined as not having a significant index.
		 */
		if (index == KVM_CPUID_INDEX_NOT_SIGNIFICANT) {
			/*
			 * Direct lookups from KVM should not diverge from what
			 * KVM defines internally (the architectural behavior).
			 */
			WARN_ON_ONCE(cpuid_function_is_indexed(function));
			return e;
		}
