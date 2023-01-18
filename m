Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2AA67298D
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjARUiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjARUiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:38:11 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3813A844
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 12:38:10 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id bj3so313694pjb.0
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 12:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0A2e8Fcuxh7F+Am+l01woHAMMexcbe+HJg2z/Rs7Tbo=;
        b=mMrH2KXvY0EZmHfxLpQND0elPtSYuAPBMQ9mhPeVuDXcfjMkr67KXT3FNetwc9rK6X
         HYPTSfKgDxWFTToHIzCskULhMJTrGlR7beQs7r/+oXwQRbLivu70wfCslkb9XL5VC1Y3
         qcqnbsPv61e0S7wyhzb1Adk0/lTiMbjBFmySnpwqia6DK1xClxRyreEH0uajG11ji8JR
         AtgvV8P82p/hfQFk7osHqIxpcyfjY9NO/Bf7EWrasH8sDYNEzyYobhaog7udHT5vKEl5
         zLy+9m0/FuYEK26KKwUfGn3v6cgLkOLxuMJ73FFhUnNdok3z5gSCMZlMrisxqgFNu+Cl
         uvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0A2e8Fcuxh7F+Am+l01woHAMMexcbe+HJg2z/Rs7Tbo=;
        b=4ULmhJ2Zd8gNVbQAN2Y1hNtoyNMJrpxfyu31NslxuqecvGt/ww0jK/MZQLeifvjzyU
         Qwxtao8q9El7/DSfSYM8MmEuOHlzycta9Z8hSCzuPwtGtTDPhmqNoSXP7PEkM6v2UO71
         GfXj++I4X9NV1tjUk2RaOJQxxxLvvbKjOoSvqTbjNmk30T3z3yrbFZjgehW9Tviit4Gy
         6B+iIr4Dmg35tf9FBD7lvxAipDJCQ8yGkTRpZ+E5J6GBFzVbumMpW9IKCdZIYzZ9u0t+
         JwIMf2RVEhr72CoSmnt9Sk7ecZOpiMr1AWjXdB2HzhfrwcV6e9rXbp2fhm4Um4GgtJrB
         ETzw==
X-Gm-Message-State: AFqh2kp/Jfgm4V5pPhfmPYOzKB0Sagmq/PMVCNC1IvJyzuPfeIahwTkh
        /ibeW3Y/Di/Pnzuo7eL6LTifqA==
X-Google-Smtp-Source: AMrXdXvdKHg8WThTL6sKpYLFQrkmWLg54eQv75h7Fik9pYFiIlg4ureVXlBr2IJDPaSYNTXPlmGc5Q==
X-Received: by 2002:a17:903:2614:b0:193:256d:8afe with SMTP id jd20-20020a170903261400b00193256d8afemr2776211plb.2.1674074289327;
        Wed, 18 Jan 2023 12:38:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902a38300b001896522a23bsm23545192pla.39.2023.01.18.12.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 12:38:08 -0800 (PST)
Date:   Wed, 18 Jan 2023 20:38:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/7] KVM: VMX: Handle NMI VM-Exits in noinstr section
Message-ID: <Y8hYrU3JDMVBSeZo@google.com>
References: <20221213060912.654668-1-seanjc@google.com>
 <SA1PR11MB67342CAA9AE9A7E766AF54E9A8C79@SA1PR11MB6734.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR11MB67342CAA9AE9A7E766AF54E9A8C79@SA1PR11MB6734.namprd11.prod.outlook.com>
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

On Wed, Jan 18, 2023, Li, Xin3 wrote:
> Sean,
> 
> Is this merged into x86 KVM tree?

No, I want reviews for the KVM patches before merging, and need acks for the
non-KVM changes.
