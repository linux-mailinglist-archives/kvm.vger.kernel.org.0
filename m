Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC2C485D40
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343899AbiAFAgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343869AbiAFAfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 19:35:55 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401AAC061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 16:35:55 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t19so1003099pfg.9
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 16:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DYZb6bhBcMHF8sxGNDirFENWW2AQ3MM20M+2kU5MKP4=;
        b=H6pEbZbadgV4TwMWNuSRh7iFZAZcDXepHtopgUT6Bzjse62pgzS0DulLYSWVCLtnIN
         OiItc7ZymeFPIK5BXHfafAhePdpe34Pi5wSXsFOJ57/TktynQMvNbkNHxzc1mFsbN1Zm
         5vgBTCn2D4N3WAb4AviB/jhDEsVlwR1V60VUWmclz0G04SzgCPlksihM5H1GSQod6u1q
         uO2Ec9HFfWL8ajhEiU5ZCqleqhU6dxWJ29nmmLcueyoxx+uYYI32DarYpU81LH0wXEaq
         U20rKVB/vXHlqMZ6jXZTKhOZWl25mERey5ZOfOt15gqR3pCFGrRprDBIa47P+TBjLPxm
         5x6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DYZb6bhBcMHF8sxGNDirFENWW2AQ3MM20M+2kU5MKP4=;
        b=4tIyDsWBL+ZBgyhEf5arUBrSE4VV6xxeDBmYFTr32DaxB9nlC81lyLoAWFIo9BdJWL
         LLg6hXcGEgNNPERkuhA+SsWIkYJ0V3soLmXZOLgm0is7XVwRWr6zOjzHphaw9M73dWig
         ygzegCN4t/bq62DVx6Z+2m8o9BWJUbBxOveeRuKktiBSr+cgbgo4R6/3J4rMVR3fxsHp
         rqwKBXrwLryMwGjyRKWRoP6A0DKMYn/6rdcLaeyFAyLsgwQr7CN/zpeluxl5OXfWdOxu
         +MC7j0hX+cyVkyo3dxO+qa1WdRqogvmix2gP8rarPG9fft99GoFUptnkDRIeThzoJEPs
         WVMQ==
X-Gm-Message-State: AOAM532b3M+vNmjy7iJlEPLB7y8oJe7XV0LfFpbMuLGqAYHeHuWkSOGJ
        byqxroPZt3rouNvbBHrY9yKpqLCaF5fYjA==
X-Google-Smtp-Source: ABdhPJy4ZJceE1AHoDiT4lvTWXTyPDw5lEN95gbeUxenfd+H6c6J/06K7AzT9sy/UQwQDbmeTGy8LQ==
X-Received: by 2002:a62:1b0e:0:b0:4bb:68f4:26e2 with SMTP id b14-20020a621b0e000000b004bb68f426e2mr58211343pfb.34.1641429354629;
        Wed, 05 Jan 2022 16:35:54 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t20sm168503pgu.66.2022.01.05.16.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 16:35:53 -0800 (PST)
Date:   Thu, 6 Jan 2022 00:35:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 02/13] KVM: x86/mmu: Rename __rmap_write_protect to
 rmap_write_protect
Message-ID: <YdY5Zummxoy+JBG+@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-3-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, David Matlack wrote:
> Now that rmap_write_protect has been renamed, there is no need for the
> double underscores in front of __rmap_write_protect.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
