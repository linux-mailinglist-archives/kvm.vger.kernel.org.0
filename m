Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E350175FC3F
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 18:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjGXQeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 12:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjGXQea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 12:34:30 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EED93
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 09:34:29 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58378ae25bfso57056357b3.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 09:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690216469; x=1690821269;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vFCy3pvszbR+X811mLdxE7uPbm807D58YR4H47bZEIo=;
        b=WVDebfufqsTmzu4NcS2X4OPVAafmBt0qkzj/yeI3YSfObAjJFBVOnkXDa9NgbRBYWZ
         02xRiMrziiriGGrA275Vti/WWguPu/aARKw1nGY4LlpgnyM5djctOPGPBNd25fLuRCBG
         Q071ME/r/fYYtIxSGL7+G1I6vTIObUisrcQ+54KQYEKi0RvZAUzpqvYjSyLmKG877wk4
         gY4TN8oq82JsJxhFY0M2LgWnESdXgjkfFinLxTERrV2wS5ih+ib/gyOSA+YNYZcjMmam
         DqMAlts09Nl0CnpjD0EREFCP9jGVhrA3yjfzpOBIj5Sr6VxxPwCZn+yWIaD+7JxGZnYc
         JIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690216469; x=1690821269;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vFCy3pvszbR+X811mLdxE7uPbm807D58YR4H47bZEIo=;
        b=fZEgbnF0sDj+D5+l397Qa0XDB07eqcv4aofcz9M/+T7d9qb11etENJ57ez8ydlyANV
         5UuTfW8h0vgk8qV2cx8tuPZ/rfgzWBvE16GLIEUn3H1lUAjexDASSYc56QiZFeYwFY1K
         KEPNh9pBSfhmgke0U50OpOwBH5rAmPLbrSAp80n1Vv4ApfpNoPQIvIcmLk0wMPHbwt6N
         kn34nqDQQMlVPDakBgcd34O8PUrDfvye/GQwPBbJuPQYy7uFNKH1pcB7G7zcCgOz3S9I
         AQWm2kvYSn8zgteyaCDuTUVYbazOntLn8xqVRvXW+opOnyQz51rEIGjHR9XWkNLDElzD
         u8Zg==
X-Gm-Message-State: ABy/qLZPdcatybtDa9tdKZ+UntnAEUh9sci1oxllKqdoSZKRruuD4FGp
        RPNOzC68j9F6Fvqh8BN7D0Tu7DjmuWFD1D2OM9oFfcEkWQrANAY5juy3C+fTdA0oZIM9z/IcC7d
        Dk5t8N/tSmJjaK0Q3tORNXrTRIP95HlPrt+Fu20ZM0p4V7m7Sjc0A1OqnOA==
X-Google-Smtp-Source: APBJJlHWlyOWOGxKFp/oV21pzD8Ff/Z/bX4IItcVCrfQUZSEfkmHlnqZv+WaPLmlGsQgYl+LapHQAiocduk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4518:0:b0:56d:1b6:5360 with SMTP id
 s24-20020a814518000000b0056d01b65360mr69482ywa.5.1690216468909; Mon, 24 Jul
 2023 09:34:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 24 Jul 2023 09:34:26 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724163426.13283-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Notes - 2023.07.19 - LPC and guest_memfd
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I forgot to hit "record", so unfortunately there's no video evidence this time
around :-(

LPC:
 - Format will utilize flexible timeslots; tentatively planning on ~3 "big"
   slots of ~40 minutes each, and ~6 "small" slots of 10-15 minutes each.
 - Schedule will be announced around September 15th (though that may get pushed
   backed to October 1st).
 - Schedule is flexibile up until the conference, e.g. if code is merged between
   September 15th and early November and obviates the need for a discussion.

guest_memfd:
 Topic Branch:
   - Work will be coordinated through a dedicated topic branch (likely
     kvm-x86/guest_memfd).
   - Mostly stable branch; plan is to not rebase it for at least the next month
   - Fixes (use Fixes: tag!!!) will be applied on top and squashed when the
     branch is rebased.
   - TBD will post a series for broader review in a month or so once
     development has settled down.

 TODO:
  - Documentation [Sean?]
  - Changelogs [Sean]
  - Non-filemap implementation [Paolo]
  - Hugepage tests (verify KVM actually installs hugepages as expected) 
  - Memory failure tests (e.g. synthetic #MC injection)
  - Get Input from IOMMU / VFIO [Paolo]

 Opens:
  - .release_folio and .invalidate_folio versus .evict_inode [Mike]
  - Fully anonymous inode vs. proper filesystem [Sean / Paolo]
  - HugeTLB (or something similar) support [Future]
  - Intrahost migration support [Google GCE]
  - NUMA support [ TBD - implement fbind() ]
  - Memory Accounting [Sean - should Just Work, keyword should ]
  - Page Table Accounting - Should we? [Nikunj]

Recording:
/facepalm
