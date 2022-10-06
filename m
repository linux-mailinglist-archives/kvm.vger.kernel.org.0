Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81035F6D99
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 20:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiJFSkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 14:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJFSkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 14:40:39 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58BF5A3E9
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 11:40:38 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f193so2665130pgc.0
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 11:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OwuwNCcudFZKvWIMInGdJ6VUhKf8xEQfCNCnX/nvy00=;
        b=dNPxFTIsfmFippclL6a+agEmeFPYHmDbHzLqSpwdwBENXUwEm5bw0G7eh6zqSKEt7I
         pgKMLnHcLZhDaANzAuCBQisU+WatxB1vZBsVRSqlV/VXLdaCZh1yxwIvwdAP76z+apPB
         1sutKYzMneuT8OOJpp46D7lh+WdugURAKQeqMvC3PR4ypIJzP+JLKIvNCeoSUZk6epgi
         b9z/sIoUZCLk0vFSaWCTzV7Pfco31lSvX22wCGziDVDEQV/COMdDj9g0RoxTi/9RoGuz
         Rz9Q3s05hUnJNMeQj3sYZzdrPpXkrdDe/lef0EZLvCWA2HodQ87LCqnvjM8OxkbwbCE3
         j03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OwuwNCcudFZKvWIMInGdJ6VUhKf8xEQfCNCnX/nvy00=;
        b=2oCFX1OTfTcChgpKG4Vex1Id1FHVFGyQRBr5Nv5qsEIUuTQRFm/Lg5BG6aj0P0ZAkd
         nqO0VOHVaKY7QGGdhdzYG+yktImfa7beWHhtQq2u7j4cJ4OWYJHrTsnM462jP77KKS8l
         BShutbWzVaOxnhEOAQp3wCIo8fG4YK88D8c0mooWpGp1Hwcw7uKZHZbP5BjraAcI+5Av
         TBTUthD/R3IgV5Dt4NUOWV5eacBjTjoCsc7xbnAD98UtkZMjzj3mLHmueP3qLpkjlmlM
         P0neUmopGMrLrNC3lNlK8ZFdaRtj8IluH9/azL58SrKNL6B+NzgH3gJTbn+1R+yr0ALF
         5IUA==
X-Gm-Message-State: ACrzQf2gmkzHKInmh3Xyq2DrqBUVLUHORPdhXMgfAkJCsgB1QgJYLFmp
        F1OASt+S9fHpADbq+cFHY1SxEA==
X-Google-Smtp-Source: AMsMyM4kBYYreOzTG1ll/1RbIjyqSM+SKO0yQvI1LfhKDALqAIEy+Rp5eXhfbc6lLUNt4daatwmhnw==
X-Received: by 2002:a63:fd41:0:b0:438:7670:589a with SMTP id m1-20020a63fd41000000b004387670589amr1037333pgj.148.1665081637959;
        Thu, 06 Oct 2022 11:40:37 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w11-20020a170902e88b00b00176b3d7db49sm1718233plg.0.2022.10.06.11.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 11:40:37 -0700 (PDT)
Date:   Thu, 6 Oct 2022 18:40:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        mail@maciej.szmigiero.name
Subject: Re: [PATCHv4 0/8] Virtual NMI feature
Message-ID: <Yz8hIY9XdlycXE+N@google.com>
References: <20220829100850.1474-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829100850.1474-1-santosh.shukla@amd.com>
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

On Mon, Aug 29, 2022, Santosh Shukla wrote:
> If NMI virtualization enabled and NMI_INTERCEPT bit is unset
> then HW will exit with #INVALID exit reason.
> 
> To enable the VNMI capability, Hypervisor need to program
> V_NMI_ENABLE bit 1.
> 
> The presence of this feature is indicated via the CPUID function
> 0x8000000A_EDX[25].

Until there is publicly available documentation, I am not going to review this
any further.  This goes for all new features, e.g. PerfMonv2[*].  I understand
the need and desire to get code merged far in advance of hardware being available,
but y'all clearly have specs, i.e. this is a very solvable problem.  Throw all the
disclaimers you want on the specs to make it abundantly clear that they are for
preview purposes or whatever, but reviewing KVM code without a spec just doesn't
work for me.

[*] https://lore.kernel.org/all/20220919093453.71737-1-likexu@tencent.com
