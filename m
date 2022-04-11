Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452FD4FC81D
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 01:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbiDKXfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 19:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiDKXfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 19:35:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBEEB1E3
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 16:33:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so847441pjb.2
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 16:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h4EBQ5KtFlqne/7MW5/+slVo7rGBhDrSQX6gK0Dbmfw=;
        b=OFG0b8pqdu8n5sNFdpHS3laQvJ0s5Iqib3uiDEjYGeKkJW3Rc4FXt81gaRg5aU50eO
         2PGcGQwd1nMQn0L6xNx9SH5wQGgC2FxPGEmxoAX9jLa5CXcAQdo1g4nnE+74K70L0Cbp
         PbE+DJEd8QyEmtxB7UoLeDe8GqziUfcNd8r6VDsd2qeA+dXOqyZ8DtlCeaXSq7GlzR7s
         ZFwVXTJ8vDhx9buZ/RQ7bnpHzl7+D7l0rW0MbV0/++2/WqrljUjimReAo1mP+ueguVvv
         EWiLUHu+C6i/SQb7oHQj8WDimM1Ae7F3e4V6+KyBNG1B0/gcVVdTIX/CSQffp/Uh30uA
         zNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h4EBQ5KtFlqne/7MW5/+slVo7rGBhDrSQX6gK0Dbmfw=;
        b=J/icmyhpgFTjPeee9qJCSJwFb3EGyMem1wnT4BiYRDyurOYfGJeP+qK/U9q70P3V8g
         +C1fj73prR7HWHlhgcOn5Vrwcucp/anmWraGvH51uQ/Iu8kvTGhvg/HHU1RWcRvuPMMg
         W1X4bwt+j23aQx/hVtQ7QzBJC6Am8N6YrXJaz2UvdcCHewQ8tf+AI5ROwoZjlZLNrPTk
         w39zQX15zo30yiyuOnmZhR14FmeOTzaLvDlXfA4WNPzSsHHV9wEveIZDrAjMeSy7G6Gf
         v2026WgC09lXqAoSthwfKPBe9va112fXlb1dLDxKvm77tzQI0MkQq2Ma/pEL8Gxp8bpd
         bOsg==
X-Gm-Message-State: AOAM533/jyc+mlYkG//NwEiBujuQTXyU0CzZzq+roCLaPFRfwu3/VhZm
        jZ2HSWrhWqLvbdqjkcsWcuPs9Q==
X-Google-Smtp-Source: ABdhPJxUb72VQrc6Q0tLG6gjaQ0T0BQktbFzQoM/KU0RsnoNeCoGqQE3D36+K/Szo0GXCy1VSn3BJw==
X-Received: by 2002:a17:902:e791:b0:151:dbbd:aeae with SMTP id cp17-20020a170902e79100b00151dbbdaeaemr35004697plb.171.1649720004721;
        Mon, 11 Apr 2022 16:33:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id my18-20020a17090b4c9200b001c75aeac7fdsm531954pjb.27.2022.04.11.16.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 16:33:24 -0700 (PDT)
Date:   Mon, 11 Apr 2022 23:33:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 7/9] KVM: x86/mmu: Add try_get_mt_mask to x86_ops
Message-ID: <YlS6wG5szNPPEFcs@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <20220321224358.1305530-8-bgardon@google.com>
 <YlSzI9ZfzPQZhPqj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlSzI9ZfzPQZhPqj@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022, Sean Christopherson wrote:
> And as a bonus, if we use 0/-errno, then we can use KVM_X86_OP_OPTIONAL_RET0()
> and SVM doesn't need to provide an implementation.

Gah, got ahead of myself.  If we go this route, the caller would need to ensure
it initializes mt_mask.  Probabably not worth it, so scratch that idea.  I also
though about overloading the return type, e.g.

	mt_mask = ...
	if (mt_mask < 0)
		return false;

But again, probably not a net positive.
