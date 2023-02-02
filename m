Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790246872FE
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 02:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjBBB3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 20:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBBB3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 20:29:35 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7A86ACAE
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 17:29:33 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id k13so406125plg.0
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 17:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tMhPzc4sc4lhlJY+eLV51FJ5n1R28Ta4xuaJDVhApbo=;
        b=ebWdmXZu4jGezhmebYzdqDkcxmqt/ChL8HjUwrBuwm6uiHCmLUDY3Mb4khnNya1QA4
         oE8kdSefcyGfQJ7Sba4QPWAa1KLcwFyK8F7kop7nGhdwschia0j7ckSzGW7OpOMDuUsZ
         H5Htzvm1HJYCL5x3moSmGRFy2IFxQ2lsdBkgt8vKWbJpPLwmnLjBicD2a61XTwbgu3Ek
         zKmBY34Oajq86U5GZbS62cNp65K8hQ4JXjLaXr70uIbxFstR5KnlkcfXmGNZ1vZcvMuU
         KZnOOiayawQ+l3YnYXJFRTcg3yACo05L040FwWCy+B8cLvWQ+Rs6S9W1ldTWJCNjxIij
         mmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMhPzc4sc4lhlJY+eLV51FJ5n1R28Ta4xuaJDVhApbo=;
        b=SJsg1EQOF/OWGl4YmTILs/g0MvovHDfLH794rXTbZsueDPQq2oOPSb0cbNqN9hlqU9
         7eE094Seqq1zHxFNjL3OYK9qPvQlKpFdztE2hqTPYfPZ/NiMnRqMDQY/qZv/UEFW/ZOa
         qpQ5xA8Ng9V+v0pAgfUN/HYH1tTxY5RBxhoOjQYmmq8PmofeSJOooNp11j7wkz1cxEI+
         A9TLy5ANBXFcnw4LgPVDKu8Eq7vWjS2tc77LN2HbsHMhvRmK6kh7R8kHZ3g3/XoFyb42
         ImO9yMihmf4fvlFZJJLlWQ5TOOE4p2gbJdEhEy2H+wk5EWev3+i2mNSDqAO7vySA1eZf
         czTg==
X-Gm-Message-State: AO0yUKW4zFjFVxGpBCw5k8vn2Jpja+bQ5RCRpwZ7vIV10FIwH/dJ8F6/
        6fRk/vnL1zFzwDy3jMce7Rmzog==
X-Google-Smtp-Source: AK7set8FTPhB/jkvNFLrwLAj0K85gyupWyV+QWSQlOZ9m+j2GQ0MmB+iWxS5ZOuYbUN/TFFq9M0KxQ==
X-Received: by 2002:a17:902:f648:b0:194:6d3c:38a5 with SMTP id m8-20020a170902f64800b001946d3c38a5mr154448plg.1.1675301373265;
        Wed, 01 Feb 2023 17:29:33 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i26-20020aa796fa000000b00593edee1af6sm4220995pfq.67.2023.02.01.17.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 17:29:32 -0800 (PST)
Date:   Thu, 2 Feb 2023 01:29:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 5/7] kvm: x86/mmu: Move the code out of
 FNAME(sync_page)'s loop body into mmu.c
Message-ID: <Y9sR+ffQ99nl4Xyr@google.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
 <20230105095848.6061-6-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105095848.6061-6-jiangshanlai@gmail.com>
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

On Thu, Jan 05, 2023, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Rename mmu->sync_page to mmu->sync_spte and move the code out
> of FNAME(sync_page)'s loop body into mmu.c.
> 
> Also initialize mmu->sync_spte as NULL for direct paging.

Please split this up, we got burned before by making one of the mmu hooks NULL,
I don't want a repeat of that.  I.e. nullify the direct hook only when it's
very clear it can't be dereferenced.
