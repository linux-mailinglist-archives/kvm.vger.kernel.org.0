Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF41E698714
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 22:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjBOVKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 16:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjBOVKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 16:10:38 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03DA10F4
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 13:10:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id oa11-20020a17090b1bcb00b002341a2656e5so103000pjb.1
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 13:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EDdD3my77qn6wRP3Aeb9AHJZUp49fzjL8qhk4LFtnT0=;
        b=NOIj+y/SIW5EXhl+5s2A0AZIelMW/4+L8sfKFwWlO/qN3ZZvPGSSSJgqvAfMXsq3Gi
         wcz5SerJ87A88bAAfMHLnM2k8MNtV+n6uSzaiGL5+9scPr6JnX9mIQ3SvLgMQTQ0wnSa
         x1J7IqoRfWj7XcYPoW+sfHCnjDsHa//AF21di/ry0nJD9QU+Ji36g5827uJii9n7RGlV
         wTV23PuMQJS/2ni4eaYD+veAnzIyscwobsgK9WpLMVqwiOJQzbLEfrpn2fBAD4o0xSPa
         zrD+/m+h1XYhDsoqqd1I+uGMgXsND0tsjutBUu5jjoK3S/vs61BIgI/Odg5VSZhEnsk1
         BBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EDdD3my77qn6wRP3Aeb9AHJZUp49fzjL8qhk4LFtnT0=;
        b=1f7y7VYnPE6dzWESztJymRD/sgKdi+RddhoyoACq/ledk9SoqYBkZbAePdDhPu08EG
         7VbGDlbk7z8cEUlO59a8oQMAtBJ7mMLRIP3jT6p0F6bdupX0n22/WmNUK7faqPbZVXAi
         y3pse64yy0na322zAa6+sd2yS24qTrUrY1n06qdSVFxw7NH381hSiJyHLVNUZKc9v/Qi
         lD4b8RFz9bPHuR5N2fCfKGd9qiWhaXJjtqnmyuAZfAGPR57bwVor5awyBJquVA7QWxYb
         lRU8KFOo6Awwvl/gd/6g+NQ7UpXA6NiZiQ9kYJ6tGe/6ySoYixjjmuLb0PPSckKJD1JO
         0p0g==
X-Gm-Message-State: AO0yUKXWj8cyXtPd61brSQgYNoNqS8GI+BTuPqEhV9HXS++lOKmiSofb
        JLfVoq7j1EtPV4FqVAsER4KpxQ==
X-Google-Smtp-Source: AK7set+GQyo0HVPK9m8l+R8hijG5IMSYZv2I8dqxXXJmjdHRJ3q+g1hr7ogYcfpSDJaPpdz0uIKAyw==
X-Received: by 2002:a17:902:da90:b0:199:38a:afd8 with SMTP id j16-20020a170902da9000b00199038aafd8mr4656597plx.19.1676495427064;
        Wed, 15 Feb 2023 13:10:27 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id e5-20020a170902784500b00189e7cb8b89sm12486546pln.127.2023.02.15.13.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 13:10:26 -0800 (PST)
Date:   Wed, 15 Feb 2023 13:10:22 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 3/7] KVM: x86/mmu: Remove "record_dirty_log" in
 __tdp_mmu_set_spte()
Message-ID: <Y+1KPhv3kyhmuy+8@google.com>
References: <20230211014626.3659152-1-vipinsh@google.com>
 <20230211014626.3659152-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211014626.3659152-4-vipinsh@google.com>
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

On Fri, Feb 10, 2023 at 05:46:22PM -0800, Vipin Sharma wrote:
> Remove bool parameter "record_dirty_log" from __tdp_mmu_set_spte() and
> refactor the code as this variable is always set to true by its caller.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---

Reviewed-by: David Matlack <dmatlack@google.com>
