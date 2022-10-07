Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239375F7BF7
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 19:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiJGRCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 13:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiJGRBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 13:01:38 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC6A2C10E
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 10:01:00 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 204so5389471pfx.10
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 10:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OR8dMoFShuSo1iMwrX1eqcqlENoHdg5Wu59OhV24q+M=;
        b=XpgEL2YeK3dNWx5sQ3EckM44GSb9m0FfHPA0iYbnk19hg2vKCBc4xzwKujVOSY7Nxb
         k5ns89vvmNpXFaXjHcRtM9QGvm5Vc9dv8IPpxD1FoRDoF9HczSWK/4F1aWdlUQ54lJ+p
         VF1EEnbwF5OIImm1Z37Jvb1cnKKYvYaxom+BZRoO/ss4toDgLcOMWLgJBgmKG2dbwLtS
         rmEwTRdMCkfO9fPK7h65J+Puh4+ZFrAeYUkOnNpvhxnDEnNDhNo8xcLTK6RurSRa0yeZ
         UYlq0SzUQZ6frXlPIGCOMV3UpsSJLR9pGkOrARgKQsYrjVQFAzMcOZfSWhO9yM2WD4S8
         DU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OR8dMoFShuSo1iMwrX1eqcqlENoHdg5Wu59OhV24q+M=;
        b=dbtpTfqzsImY1EHqYj9wTT81D1eZR+1c7ImO86SNbKGmAZjVt0KlyaPxYTfVjeN7Gw
         S5qWJb0av7W0rvgor6YS46ILNsCH5w4CT7wuqFyafYTsp4UuiJ41q+sbDdSNtLdiMC41
         7RreG0KJ3k202EGAmDAjjgnT8NzrPC0b32taMD3Aeu5cszlMZquzgnN/WQsFu5pV95eo
         e9LMc1aSHLJZbKsapi/q2Hl/ZIcagDBQRolsJ9pjzmlonrCCn5nzDWzX6uJC84uj1rMr
         M+TAqLwd9ExHaj2ko3NIxP4xymHT1QURwahUE66Cz0KRN/wjTZ/n3g17X5vedNhhKdPz
         kkfw==
X-Gm-Message-State: ACrzQf0l1n8vGTgN9Ek1GlQZwT7qq5YqYQMLop51RE0q3t8fIEaiWssh
        SGtMNFurOceES84Z35MBw8pyMs3k4orDMA==
X-Google-Smtp-Source: AMsMyM4A3t18r13dwW7oVHjRZ3vN3VFrgdqssilWSCXapCyxGUH9XhZ7WO+RSbI7kVFN+Ids55tkIg==
X-Received: by 2002:a63:1f1d:0:b0:446:8e68:f4b2 with SMTP id f29-20020a631f1d000000b004468e68f4b2mr5335169pgf.391.1665162059837;
        Fri, 07 Oct 2022 10:00:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f142-20020a623894000000b00540b3be3bf6sm1847004pfa.196.2022.10.07.10.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 10:00:59 -0700 (PDT)
Date:   Fri, 7 Oct 2022 17:00:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     "Kalra, Ashish" <ashish.kalra@amd.com>,
        ovidiu.panait@windriver.com, kvm@vger.kernel.org,
        liam.merwick@oracle.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, pgonda@google.com,
        marcorr@google.com, alpergun@google.com, jarkko@kernel.org,
        jroedel@suse.de, bp@alien8.de, rientjes@google.com
Subject: Re: [PATCH 5.4 1/1] KVM: SEV: add cache flush to solve SEV cache
 incoherency issues
Message-ID: <Y0BbR7o5OZg59Bc8@google.com>
References: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
 <20220927000729.498292-1-Ashish.Kalra@amd.com>
 <YzJFvWPb1syXcVQm@google.com>
 <215ee1ce-b6eb-9699-d682-f2e592cde448@amd.com>
 <Yz99nF+d6D+37efE@google.com>
 <CAL715WL4L=9vhhU3TvY7TOe3HZ73weWFNiaP2RyBtzN-kZ4EoQ@mail.gmail.com>
 <Y0BK9/uo9eUE1RKb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0BK9/uo9eUE1RKb@google.com>
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

On Fri, Oct 07, 2022, Sean Christopherson wrote:
> On Thu, Oct 06, 2022, Mingwei Zhang wrote:
> > I have a limited knowledge on MM, but from my observations, it looks
> > like the property of a page being "PINNED" is very unreliable (or
> > expensive), i.e., anyone can jump in and pin the page. So it is hard
> > to see whether a page is truly "PINNED" or maybe just someone is
> > "working" on it without holding the lock.
> 
> mm/ differentiates between various types of pins, e.g. elevated refcount vs. pin
> vs. longterm pin.  See the comments in include/linux/mm.h for FOLL_PIN.

Ah, after catching up on the off-list thread, I suspect you're referring to the
the fact that even longterm pins don't prevent zapping[*].

NUMA balancing - already discussed

PMD splitting - If necessary, solvable by introducing MMU_NOTIFY_SPLIT, as a true
                split doesn't reclaim memory, i.e. KVM doesn't need to do WBINVD.
                Unfortunately, not straightforward as __split_huge_pmd_locked() may
                zap instead of split, but it is solvable.

KSM - absolutely should not be turned on for SEV guests

[*] https://lore.kernel.org/linux-arm-kernel/YuEMkKY2RU%2F2KiZW@monolith.localdoman
