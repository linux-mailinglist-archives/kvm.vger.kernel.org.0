Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20683578701
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 18:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbiGRQJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 12:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235539AbiGRQJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 12:09:08 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2712AE083
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 09:09:08 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c139so4737167pfc.2
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 09:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l8qapUCviI3zj7LkmoRMmCuX099KlOcg/kQDL6SCQ1U=;
        b=c++s6kMh7FF4gl4v6bZs6r/mbUhYrDciihhzTrkspqpDmHy7YTEh5NA37dTPYILBO+
         +H+uOt2LK9DG0R+Aj/xKnf2m5IpX/gq2uF1AHfdiaKK9AgoK/3Rqej7GLT+4VWEKksxl
         JbsFbC5TIfGVALpY67UkkzcQr6d7v6mI8sfU+dFw028ZO8CpJClhvEhsewdKVu7ARTJ1
         7av5IqG8t2AY4rxtGMz/qs3O5LXn38Ye8E6Lh6RJqcNdhkSi/1EGotLRVt8QhJyXeLu3
         QDWu5P++TT0mIEAIPlQM0E6b8ZCjHJdrHFDRw38eynh1dRCp7VFYFqzJ07A7qPy1txIq
         WdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l8qapUCviI3zj7LkmoRMmCuX099KlOcg/kQDL6SCQ1U=;
        b=ZJ7xZBB8hMkT1EresZqBswJnMr4IuN0j31DExJbv6sha3j7sB89ItFkJmjP/U7lQGa
         EHhpI3JDInRbvZUd34YqFQXZz3e3yp3pL3P7HdS3sdw1K5mwCFT8MC7evnTsMb+RqLfD
         jAz3Oj4+wotSg6XDhwol+QI7/OZKSYDUDQRy4D38N17HALnW0ua121fL+Ifra8qKC9eJ
         2hkXbXMLuZXs96AwPMVZHpcIk7hGFWOZYwb8PQncvBJDBE2tz6UPRBWj2LCqu9BhtwWE
         gX0mZsno4SyhE/pJtNPPJQH/Qx3HNpGpdxhgzO8KI14oT0SE2JKn2SSdFCenIIRu+1hm
         YUuA==
X-Gm-Message-State: AJIora/uXrur0zlFFNXjmFNMhue/W+yVi0+Qamu5KYq5nvB758xXTyKH
        SSReYvXpQW75XvmuXAL5viIfig==
X-Google-Smtp-Source: AGRyM1vNdmCprynRmwKVFdtLPlXbdO8TwXLUQSXks1FdV8FsjNQa7nKtvL4VUIdbAw1N1LnFqUsWVQ==
X-Received: by 2002:a63:210:0:b0:419:c604:2c2b with SMTP id 16-20020a630210000000b00419c6042c2bmr18629368pgc.190.1658160547512;
        Mon, 18 Jul 2022 09:09:07 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id im16-20020a170902bb1000b00168dadc7354sm9704150plb.78.2022.07.18.09.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 09:09:06 -0700 (PDT)
Date:   Mon, 18 Jul 2022 16:09:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KVM: x86: Apply NX mitigation more precisely
Message-ID: <YtWFniBENSKqZ8tT@google.com>
References: <20220409003847.819686-1-seanjc@google.com>
 <YtTv2EK4wJDjhjSj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtTv2EK4wJDjhjSj@google.com>
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

On Mon, Jul 18, 2022, Mingwei Zhang wrote:
> On Sat, Apr 09, 2022, Sean Christopherson wrote:
> > This is just the kernel (NX) side of Mingwei's series "Verify dirty
> > logging works properly with page stats".  Relatively to v3 of Mingwei's
> > series[*], this fixes accounting (and tracking in the nonpaging case)
> > of disallowed NX huge pages.
> > 
> > I left off the selftests because I disagree with the "Dump stats" change,
> > and this has snowballed enough.
> 
> Hi Sean,
> 
> Ping on this one? This series might need a rebase and I can quickly
> provide the review, since several issues are blocked by this.

Sorry, I didn't realize (or more likely, forgot) that there is stuff depending
on this series and had it lower on my todo list.  I'll get it rebased this week.
