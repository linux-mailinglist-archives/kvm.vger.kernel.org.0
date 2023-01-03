Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5670B65C8D2
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 22:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbjACVT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 16:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjACVTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 16:19:07 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F6725D4
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 13:19:06 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o21so4052155pjw.0
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 13:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c3u4viFf4xTjR77nQ+iN3D/WVZD7odj3dDROxrzHS78=;
        b=dyf43qxv95faYYtccBnBODi9tn+YtYQiEUinhWbNp5MX3EWJhsZ9X15/P/Dt9QWb4N
         hUUpTXEEJfwsqQgKnE/MYcAamYefLp1pkwUpGqnD8Knz7ls/aY+4AmM9gKvLvlmvzkTx
         q3BgHiXoCsUd6x05LXCsLYNBTgu2LPrA7gkiTvupqrKxy+8LVCX9gNp5V3mrj++k/Uoc
         jDIpurpOJtSk3WfA0Xesle/v/SllByEl6pLvTkB1oVFhqtKigbPwsxHY8KSValZf+1w7
         eEBGKcYBblNYQ1vTB1NZMx6eXx1r5g3qh/GKQddP+TS7F5WsR4XAoF1MGPRxeb8hXeA6
         2eug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3u4viFf4xTjR77nQ+iN3D/WVZD7odj3dDROxrzHS78=;
        b=1Djlr2iW+ADdGuIfT03MpkYAnasQAVfa21et0ZZkdPzx7BF2wkpJvE3n6KXZhfAgt9
         yVlydILQ0JBUnQdnnbCykdbpe92ZRgs6mm7y8J9AqILy3g/DiQiDQ+4hLZps0qDWLLNp
         RHlDTL/UxqayfD3OxPpWuf/OEg4cjogvZHswe4pELMeVfkaDYcdfNBjyms/jXg/3jwEC
         MzMmRIEL7yijfGBivOpT+4oGe5Lhp9ovXyR88oE9vdkzBqhMY7lEYAmlnFUt9AauD/29
         pg9DCMpaGqw66lbd6uz6hA9GB32Fhmj+Q02yyv7cKaIUbRvWV3jlUa2dZEcjQB5PsKb9
         KDow==
X-Gm-Message-State: AFqh2kpvj/8FmayIcA6TGbXmRE8lYh8XuChKw8XgDBw03wjM50RDZ8Ng
        WAEhMApfvHOtw3GBrg5f8UWI0g==
X-Google-Smtp-Source: AMrXdXsRrvuXTzfkRt6Y5pbAIJNM2f3D+xwjUMpE2J4UbGs3IWYjjgM7o/7PQF5PzULnMVN+gIs1QQ==
X-Received: by 2002:a05:6a20:2a9f:b0:a4:efde:2ed8 with SMTP id v31-20020a056a202a9f00b000a4efde2ed8mr4997943pzh.0.1672780745919;
        Tue, 03 Jan 2023 13:19:05 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k12-20020a6568cc000000b004788780dd8esm19141338pgt.63.2023.01.03.13.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 13:19:05 -0800 (PST)
Date:   Tue, 3 Jan 2023 21:19:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 26/27] KVM: x86/mmu: Add page-track API to query if a gfn
 is valid
Message-ID: <Y7SbxcdYa7LKR43f@google.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-27-seanjc@google.com>
 <Y6v287BFez8tU43e@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6v287BFez8tU43e@yzhao56-desk.sh.intel.com>
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

On Wed, Dec 28, 2022, Yan Zhao wrote:
> On Fri, Dec 23, 2022 at 12:57:38AM +0000, Sean Christopherson wrote:
> > +bool kvm_page_track_is_valid_gfn(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	bool ret;
> > +	int idx;
> > +
> > +	idx = srcu_read_lock(&kvm->srcu);
> > +	ret = kvm_is_visible_gfn(kvm, gfn);
> > +	srcu_read_unlock(&kvm->srcu, idx);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_page_track_is_valid_gfn);
> This implementation is only to check whether a GFN is within a visible
> kvm memslot. So, why this helper function is named kvm_page_track_xxx()?
> Don't think it's anything related to page track, and not all of its callers
> in KVMGT are for page tracking.

KVMGT is the only user of kvm_page_track_is_valid_gfn().  kvm_is_visible_gfn()
has other users, just not in x86.  And long term, my goal is to allow building
KVM x86 without any exports.  Killing off KVM's "internal" (for vendor modules)
exports for select Kconfigs is easy enough, add adding a dedicated page-track API
solves the KVMGT angle.
