Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618824EE145
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 21:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbiCaTEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 15:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238038AbiCaTEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 15:04:44 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC20B20DB01
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:02:56 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n18so430046plg.5
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Btlfi9u0cv/7pW0yWqfr1LdiIwUsA5YGvmZWg/HVlkY=;
        b=R5ZihntLCRzvgu6ZJtpoWuH5yh8cT9Yt81Z7BDIdt626MFW9xrrQyJXziYt0Jv5oRU
         mFe75yFpqAYqZt4NDeXMRbjduKiAq4htdLcZmglBbWSjSGS/VrtaEDCLV1RqaWSmpRQZ
         Uv2NlghAkcDKup+FiOBA8/qEsYKNepX4DdW46etO9EottizjKLuoLn+y16qmXzCoRbVc
         TybS2OkK0RElfTCJW45I8LJ2/oYiVOtfpjyuRQVmWh4DFlXCtbyTwwbwdv3sKp3tn1nJ
         dsn6nlezNFIcXL06mbieB/VztJKJuMmRE/iUg8kvssRf3qAwruoBd6FVSGgGHW0lHGzO
         hKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Btlfi9u0cv/7pW0yWqfr1LdiIwUsA5YGvmZWg/HVlkY=;
        b=UqA7c15YOEnzjxJI9HGZG2ur+s6Y3WEf7wG7D3YTuNnlVK64hbYubLVcSTnpmfzlal
         X7PcCRiA9mVpGrwycYejgthf+OohHPJR1CO6CbUEbQFuvZCL5R6o7KvuxmR6xAVg/R6I
         R75d4hF2R1uDXoRxkdNbvr07TWztOCQ5P6kQrWjmod0bEScdH+SkEct2hxV1nls6AVUn
         Db8R745KWpj/LQPRJit3/hvejvXtrcB5oRyJexKXW341SSj6/fJBWpfqh/gT26SEc5Nu
         Zb6KwIoe9XXRlFJolAAIsT14QlUcH0ihNqJVjkqXI/d27bRe6eGwUHVCgrsEPJCxXXUY
         5h2w==
X-Gm-Message-State: AOAM531rqQ3mJVqCYU3IMJ9SZv01Fr/4j1rd/9WJVVBRsDQ+FqVar+FW
        I4uhu7BZ/NRya+aXvl/vt0G1cQ==
X-Google-Smtp-Source: ABdhPJwiwMc612ifEugRgefZeGQbTSzqzjIxRK0MRHNUAO+FYZ4sWZdI4SerXlLDAjDCNBi5jOybfQ==
X-Received: by 2002:a17:902:a981:b0:156:52b2:40d6 with SMTP id bh1-20020a170902a98100b0015652b240d6mr5998107plb.34.1648753376099;
        Thu, 31 Mar 2022 12:02:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p4-20020a637404000000b00375948e63d6sm84514pgc.91.2022.03.31.12.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 12:02:55 -0700 (PDT)
Date:   Thu, 31 Mar 2022 19:02:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <YkX63IWfSwgjqa0H@google.com>
References: <20220330182821.2633150-1-pgonda@google.com>
 <YkXgq7hez9gGcmKt@google.com>
 <CAA03e5EcApE8ZnHEwZdZ3ecxYvh1G3nF-YDU5mhZa-15QZ0tew@mail.gmail.com>
 <CAA03e5Ghw6rJ82GhGKW+sCDgDRpZPLmhq29Wgmd0H40nvbX+Rg@mail.gmail.com>
 <CAMkAt6qr7zwy2uG1EaoZyvXnXMZ7Ho-CxQvRpcuUCx8wiA+6UQ@mail.gmail.com>
 <YkX46P6mn+BYWsv2@google.com>
 <CAMkAt6oiXaDfzRWo0GDNGyFeA2f8DPmWGsJvpFpB1+A8XSz4rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6oiXaDfzRWo0GDNGyFeA2f8DPmWGsJvpFpB1+A8XSz4rA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022, Peter Gonda wrote:
> On Thu, Mar 31, 2022 at 12:54 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Mar 31, 2022, Peter Gonda wrote:
> > > I'll make this 2 patches. This current patch and another to rate limit
> > > this pr_info() I think this patch is doing a lot already so would
> > > prefer to just add a second. Is that reasonable?
> >
> > I strongly prefer removing the pr_info() entirely.  As Marc pointed out, the
> > info is redundant when KVM properly reports the issue.  And worse, the info is
> > useless unless there's exactly one VM running.  Even then, it doesn't capture
> > which vCPU failed.  This is exactly why Jim, myself, and others, have been pushing
> > to avoid using dmesg to report guest errors.  They're helpful for initial
> > development, but dead weight for production, and if they're helpful for development
> > then odds are good that having proper reporting in production would also be valuable.
> 
> Sounds good to me. Is a second patch OK with you? I think we get a lot
> of cryptic cpu run exit reasons so fixing this up when we remove
> pr_infos would be good. This would be a good example without this
> pr_info or this change you'd have no idea whats going on.

As in, a second patch to remove the pr_info?  Yeah, no objection.
