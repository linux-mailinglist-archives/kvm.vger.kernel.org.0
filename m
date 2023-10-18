Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AB47CE181
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 17:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344766AbjJRPqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 11:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjJRPMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 11:12:41 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAE0EA
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 08:12:39 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9d4e38f79so55420885ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 08:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697641959; x=1698246759; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=evf98vIg4TK2MPQBLVBmj385x0hMw4FlsTtUwU11DSI=;
        b=d51R1t+jYNyCrVgXhpOOE+dXe6Aovx8stHBG7TKoKEwls9axz0dTXnX4CDatWJDU+1
         hvtIf/d1v+DG36x6GiTkAdnYOBkOYqMfm/EadTzUqYKRsi8pnLrN0nfkC77DrztuY5U1
         hfG2E4dyIqMDIWCGEXjTNFNh+SDeDBP/WyfIhbHiXSSddfk6j2RRUpwCwA758UjJ6qMl
         ITjlHy3V+vtSFCZKF+dVtD/BEB291uf+sJ3+kZTBUnn7twKO2FvI3Q7Sq+EkNjFs+kv8
         q2YNnBUURURdeIED67nXUqWRObxPzaMLCo0z4jWPdKO4xYGwNR8BUj7wME172RUJQF9Q
         m9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697641959; x=1698246759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evf98vIg4TK2MPQBLVBmj385x0hMw4FlsTtUwU11DSI=;
        b=qN/+UBAesZ54js9hRtxUE/DDk2n9Z20rY1Wp1qwHMEGLIuSsrSqmmFlBPhWgp+jxG8
         lbt8tZYJzicFkLdeU+r3zFRbLzGDen8T3TIUf1QyXBTt4mABM5yyjCJWJm7wajimJtLK
         PJ0pIydCthzlI3HnJhb3QJYLoI2o6qcKUIuf46IeIyHeknYRBuU21xfiz9cskB/lUn1v
         ZD7/Q+QpTl8pgDQ5HY1sfA9X5GbpcHdn6HDEZGMCJCkfgoyD0wIcXxKJsSqaD5q5M7JS
         H6r6clnGDfi+VICX6ygj6Dn4GHjOuprfiBaPpkqtUjIE1Om2ljL7/qeRL1xMQhKQOL27
         VXPw==
X-Gm-Message-State: AOJu0Yy44NsHdXNS8ouYKyp2QfpegxI1Sb/x2WyA13BAu7nHXhyOqtOz
        DN6s72PDaD2k6yO8vg7gnFQfjWVYZwM=
X-Google-Smtp-Source: AGHT+IGGj6YD1tNGtkylhZ2TMrFEwNGuXiRirTZJm64uFeGyC2oRhC4jwU5nYGby5n/F7k9IPGht2AGbZO4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:328a:b0:1b8:8c7:31e6 with SMTP id
 jh10-20020a170903328a00b001b808c731e6mr130834plb.1.1697641958822; Wed, 18 Oct
 2023 08:12:38 -0700 (PDT)
Date:   Wed, 18 Oct 2023 08:12:37 -0700
In-Reply-To: <020adf4b-5fd9-4216-9dac-7dabe53617d5@intel.com>
Mime-Version: 1.0
References: <20231013070037.512051-1-xiaoyao.li@intel.com> <ZS7ERnnRqs8Fl0ZF@google.com>
 <020adf4b-5fd9-4216-9dac-7dabe53617d5@intel.com>
Message-ID: <ZS_15SGIhtpzJ8Gr@google.com>
Subject: Re: [PATCH] KVM: x86: Use the correct size of struct
 kvm_vcpu_pv_apf_data and fix the documentation
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023, Xiaoyao Li wrote:
> On 10/18/2023 1:28 AM, Sean Christopherson wrote:
> > On Fri, Oct 13, 2023, Xiaoyao Li wrote:
> > > Fix the kvm_gfn_to_hva_cache_init() to use the correct size though KVM
> > > only touches fist 8 bytes.
> > 
> > This isn't a fix.  There's actually meaningful value in precisely initializing the
> > cache as it guards against KVM writing into the padding, e.g. this WARN would fire:
> > 
> > 	if (WARN_ON_ONCE(len + offset > ghc->len))
> > 		return -EINVAL;
> > 
> > So it's a bit odd, but I would prefer to keep the current behavior of mapping only
> > the first 8 bytes.
> > 
> > Here's what I'm thinking to clean up the enabled field (compile tested only,
> > haven't touched the docs other than the obvious removal):
> 
> It looks better.
> 
> Will you send out a formal patch yourself? or leave it to me?

Your call, I don't have a preference.  Just let me know which option you choose.
