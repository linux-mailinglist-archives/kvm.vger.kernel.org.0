Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4B55F7F71
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 23:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJGVH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 17:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJGVH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 17:07:28 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3572275CD
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 14:07:27 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 207so7116240ybn.1
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 14:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y+w+UZ+1knR1/g5ltwOgnrO6wBkZ5WkRRMZI6pICUDM=;
        b=F8SluGgjtBH1353QWyAg2iPDBYHa3skTGIjYwSvHtm/YmlqPYKVTefNGuN5hu4NC77
         K9awj8C3IWo9vqh4fqlq3yDsh2Hqsce3euAWeVPLs/PkmyDXXCbMvdVx4WNpsW80xhFU
         AWCzR5XRVFPJykKU8FbqpcAOtEsS+/PKBa5juAkcXC6NzM0I45/indD0ljvfXMB9jxUH
         em6bGZBfxwQw0opEpkqocJbhU+dPdV9K6MpO7eP0RmmiH/S9p/FpENlMNfl7bDWoKWQY
         uy/u+FPstxEFhOdXBHIwowhXQM8aOHYp55hi2HrB5s1aFcWNl+Od5vCuGcwVH9iZx2jU
         YskA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y+w+UZ+1knR1/g5ltwOgnrO6wBkZ5WkRRMZI6pICUDM=;
        b=wSY6UfOtLdZ6S3mXcVFcuDIsAqwFZpyK32GW6fcl+ZdKBCRb3Uq1TJSPOFCIlqZN5u
         ISPVeSLySCWO7eQL2bgjcr1ebIjxM/DWqgnpNeysjoCn33P2cIL6xf8j770nwA/Qr/JK
         y99oX+ykagv2RidkAfCg21m4jXEaO3M7XHD6hobWakNUPmsIdFd5ySGV5NKghhfjX5hy
         jSDJIjFkxT/s9qwnQAaFnljr7bW2W+b5F+FUyGJNgHrF9WV6JwxKpLCADB+6X/OwGluE
         evh6sFRFxD4VDwYOK1fw2KjUP+wFHvY3ag3K7xUhgy9jRppmUQ3SsBEBGQWNgUjSyn1F
         BTgA==
X-Gm-Message-State: ACrzQf1+7ZhRL8g9KOCPJQyPfUAWLUb4vr3GZR5/bk0Bhy/G2H4H7/Q/
        av6a1GoFndmI3d1yIWEtTmIhhNTrDFb9kCj2sle6sw==
X-Google-Smtp-Source: AMsMyM6BlsmpkFAJDQv0f0xfJJx74IuadWGBU/wThujFa3XoPLbJrObr2QElA6zL0w07hq5fnOP6Y+UMEf1YvjB5i3k=
X-Received: by 2002:a25:d457:0:b0:6bc:92dd:9462 with SMTP id
 m84-20020a25d457000000b006bc92dd9462mr6818617ybf.326.1665176846906; Fri, 07
 Oct 2022 14:07:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220912195849.3989707-1-coltonlewis@google.com>
 <20220912195849.3989707-3-coltonlewis@google.com> <Y0CSOKOq0T48e0yr@google.com>
In-Reply-To: <Y0CSOKOq0T48e0yr@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 7 Oct 2022 14:07:00 -0700
Message-ID: <CALzav=eJ9F9-MaYehBUMU96_O825OpZqB72=9is3BDi24WL=Vw@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] KVM: selftests: randomize which pages are written
 vs read
To:     Sean Christopherson <seanjc@google.com>
Cc:     Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        ricarkol@google.com, andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Oct 7, 2022 at 1:55 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Sep 12, 2022, Colton Lewis wrote:
> > @@ -393,7 +403,7 @@ int main(int argc, char *argv[])
> >
> >       guest_modes_append_default();
> >
> > -     while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
> > +     while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
>
> This string is getting quite annoying to maintain, e.g. all of these patches
> conflict with recent upstream changes, and IIRC will conflict again with Vipin's
> changes.  AFAICT, the string passed to getopt() doesn't need to be constant, i.e.
> can be built programmatically.  Not in this series, but as future cleanup we should
> at least consider a way to make this slightly less painful to maintain.

I have aspirations to consolidate all the memstress (perf_test_util)
option handling within memstress.c, rather than duplicating it across
all tests. That will help cut down the length of the test-specific
option string (although I haven't found a super clean way to do it
yet).
