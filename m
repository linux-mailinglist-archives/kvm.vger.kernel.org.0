Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A034ADEE3
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 18:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383696AbiBHRG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 12:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241712AbiBHRG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 12:06:28 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C50C061576
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 09:06:27 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso3473553pjm.4
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 09:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LoDIVn3ps3QDMfn4s5pDjeHxnamculzSXR1qGxqJBOY=;
        b=nhMz3QdCgfMXgktDsIIGLV2t8V1grYKysV+gVh7JP7bqwVjU9qJmzKTMZ29+63PwAW
         rtqTED70bllYgBYK/Yw2XtgH82p/PMyMZt+VGHVrZ56b/7B94lb7eg/kV+trCncsKlxx
         oWH25F3DZYpxEG5G4e2N/aisXSVVdYasKxuZJiGiCHegkU1LO3Rz7UPcawiR2nNS3jrr
         6JfldqLX9or2AZtGZPDhfJnqS4qQDYwHfuysn007BHR2Q9HpHceLP84yA7l2IC42HYnK
         +8ytFI04DLzLlKf4NfN8y5FCeIu8SncZg+KPuT6AygV0PA8Uv/7lzQuIm5RZ36dvZlMF
         WTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LoDIVn3ps3QDMfn4s5pDjeHxnamculzSXR1qGxqJBOY=;
        b=5lFHdmdYhsnt9HpieBsj4E++2zUgLX7+PT3syswlr7snsRM1PpIebKZYaoznlEKe3y
         sfx7Glt7wUkblIgSlIivunuXp3hk4e4j+NjbBuTFkce03wPjel7koUgDgdDRa0khksc1
         NPDuDRbha038KKbp2Wq4kh1EcwH5pEIogBlLWgcemNt2bg0G9xBvstD1iQzim56yKLLf
         pvwPXB2YYT1isso6ucG1uIJtzChOrj4i684gTFCsDWu+y6TQBVa8/toy0dZ+3ALQZ4xQ
         gmY9G4tiHfMCjz2MEBv/3Mrv57bRbmPhtNfL62eYEwL4hthGtpvUM6Q0Y5ZHd16v/NaP
         Z1dw==
X-Gm-Message-State: AOAM532TYfOk3vo/Haj6WKDzotlY1yi7YoHiLXhIU7Qj4C+vugTa0QWo
        h8Jv7ZHC9sbWknSeUWdP4fIMlA==
X-Google-Smtp-Source: ABdhPJywOJWg5pcFJtajXypQ8nT3gQjRWmNu01AdTbevL+lrP7VgkehmNi2mwkxKZeqM3FlhBPjaqQ==
X-Received: by 2002:a17:902:d3ca:: with SMTP id w10mr5624205plb.33.1644339986849;
        Tue, 08 Feb 2022 09:06:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h6sm17138993pfc.96.2022.02.08.09.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:06:26 -0800 (PST)
Date:   Tue, 8 Feb 2022 17:06:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: warning in kvm_hv_invalidate_tsc_page due to writes to guest
 memory from VM ioctl context
Message-ID: <YgKjDm5OdSOKIdAo@google.com>
References: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
 <87ee4d9yp3.fsf@redhat.com>
 <060ce89597cfbc85ecd300bdd5c40bb571a16993.camel@redhat.com>
 <87bkzh9wkd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkzh9wkd.fsf@redhat.com>
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

On Tue, Feb 08, 2022, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> > and hv-avic only mentions AutoEOI feature.
> 
> True, this is hidden in "The enlightenment allows to use Hyper-V SynIC
> with hardware APICv/AVIC enabled". Any suggestions on how to improve
> this are more than welcome!.

Specifically for the WARN, does this approach makes sense?

https://lore.kernel.org/all/YcTpJ369cRBN4W93@google.com
