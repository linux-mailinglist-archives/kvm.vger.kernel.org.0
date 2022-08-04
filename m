Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50037589F6A
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 18:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbiHDQa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 12:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239525AbiHDQaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 12:30:06 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7AD6BD43
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 09:29:41 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f192so10340706pfa.9
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 09:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=q8RwhtZq6TW58usigmUZWjntYIHfu3sCijbnVmJzpu0=;
        b=LhsghDIxddKvkP0BwyWDMT/+d3pDLLNRFKgs0mGiVfARc3brHtAArB+f/msTXwrQdZ
         jidv8MRtakFS8+Be3IE7f29sPjWWRENQFQVtpCUu/5LWW8HxCpaW53vYMn2OnMVzN+Re
         1xpEOrAaHSYEmi9M4algc5ByG1QAaMqfTvUsRxZk+0dYcMOgFe9VaM1eZ1KK8H+O33tl
         zcLAuMOi8S3BnCNi+tgXe0ASl2bofDvaaUzVO/0PuBtUR0OUn43FfGMCVKfKDxXd70tP
         eAtzKdOP3k8iVvcl77PXgEho+GeKWrzSPvk5nlqc7kdQM6qJci6qqcZwZt4tK8J5OE3T
         LA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=q8RwhtZq6TW58usigmUZWjntYIHfu3sCijbnVmJzpu0=;
        b=N8c91DSznr24vOdL1larhZ8UWq1+UcQwJrhLAryPsITsbSb4UggHTpA5+4vothkL5R
         jlp4i7ZHAFOjh3Baix2VAH3RbYj13JrDNvRZSxPMr9h2VCxr2EkDxKc9wSMtgRy7vVZk
         BZqwrWKvp0whNt9DrcaXrK2mGKNWed8VZ8RlEyRJJ3LhUCBeXf62/HXLEa28K3zugJIZ
         Mv/VGloPy2gqgnQeeU83kM/rBF3eAuwywl0+ExmH2EwNsc9YWCv7wixaxa/4IiMf5Ox/
         kmXGQUKICCAP74UniYt/dBMtGHE38TmLAhrw7/JEPmmyRJOSgSnFemRpnLCG47fZ96xN
         phPg==
X-Gm-Message-State: ACgBeo0Y7p35WBxSrUjn6/HzezHaI/XnIeBplPKRN0SPbmr5cUrHL/qG
        6QSo0aVphc6c4G4J0sXB1nBpMg==
X-Google-Smtp-Source: AA6agR7YvFipLZjJznpVd3FTSRMZrcsUT/gX71fNbZ6++73pMGPf6ybNwx2ULNcq12p5Nn4YAAd3jA==
X-Received: by 2002:aa7:8c51:0:b0:528:2ed8:7e35 with SMTP id e17-20020aa78c51000000b005282ed87e35mr2453400pfd.13.1659630580438;
        Thu, 04 Aug 2022 09:29:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u14-20020a62790e000000b0052d78e73e6asm1132711pfc.184.2022.08.04.09.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 09:29:40 -0700 (PDT)
Date:   Thu, 4 Aug 2022 16:29:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v3 1/5] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Message-ID: <Yuvz8BbOblFAgDLW@google.com>
References: <20220709011726.1006267-1-aaronlewis@google.com>
 <20220709011726.1006267-2-aaronlewis@google.com>
 <YuvzHkmU2DsBe6Rj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuvzHkmU2DsBe6Rj@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 04, 2022, Sean Christopherson wrote:
> On Sat, Jul 09, 2022, Aaron Lewis wrote:
> 	if (entry) {
> 		pivot = <compute index of found entry>
> 
> 		/*
> 		 * comment about how the key works and wanting to find any
> 		 * matching filter entry.
> 		 */
> 		for (i = pivot; i > 0; i--) {
> 			entry = &filter->events[i];
> 			if (get_event(*entry) != get_event(eventsel)

Just saw Jim's comment about using "key".  That would indeed make it easier to
understand what this is doing.

Note, the missing parantheses throughout aren't intentional :-)
