Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4475377F98F
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 16:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352187AbjHQOqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 10:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352300AbjHQOp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 10:45:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5333593
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 07:45:42 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-586a5ac5c29so96804307b3.1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 07:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692283541; x=1692888341;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KM80ZNnp20PNpo/anqlhgUFa4QpjUiNpC9plwfXLRWA=;
        b=QjPyI4XI8622SbvZoKVpJTnnqWN3JkJe21W0wVXqNzUtBrfG+OQ7URD3633OL7QUNb
         7jK52Cwb8PjbQd4EpdX6HNBT0OAzBM8K3WLRdWFgL2S4PZ2HMxqHxr+YujCOej2Pty4W
         VDInswRbwKMiZ9w+zvTgR9DK1Ahct/5bFssTvnmUvQnyehc/j3c3cjr+rvBUi7jmLxiK
         rHNmYvguBJFY0mWfOysXcYsizU3Ve7O+KDqLxmK9SI9zgkKvlPxZniMOdW2ZjoN61vwN
         sTzk1yRsuCvADiL/OUfsyZXXN7HY0VD3f6UOiRJVPera36gE0QR3vYurbsErAEYYn2fq
         JNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692283541; x=1692888341;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KM80ZNnp20PNpo/anqlhgUFa4QpjUiNpC9plwfXLRWA=;
        b=WR7trrVK6jVJsXkR79BpD+oyiN//b8t8XIXjFU1O1g9T6/39Jt4CvfcooPdIxKN3E3
         qnS4t6TFW1sKzfNXYASQ9PfVK54VQ7vtQ26ajyQvjA06qawUM7uoTE8ZXmHwvKKNJVtB
         sbqYZA94RSdsy0xNoWTDiMawXsitHRyJWWRJHa1B4KHTFx/iYQbeWX+3Vk2cDUcGeZl/
         JjhcNb0pn9YNdtYCe5c/7SrUjb+73gSPIr3oOZc4CN2Qjs+bY+QZi/WllNa6cuzdbOy/
         +ue5WoxWTd1wLBn5Y5SHyDRQL+FbzTT0l7TQcLGqDZRRXOQ7m/GqsueUI4el4zfE6JlH
         XUDA==
X-Gm-Message-State: AOJu0YyeiRvxJA+fn4HYg19aZp+qAo5U40yrkf7sQf2LVP9V3Qnr+9eB
        qtsmsTq+YIwI6vaC0LZAVKF1jUEwRIg=
X-Google-Smtp-Source: AGHT+IGHzC3HJHyiKi0mKqHVraRuZMM66a306NXB9BtkJmOJ1ZQlDhwwBy8Zkq73uiBQK9AAN/ZN0YYFZYs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1828:b0:d0e:d67d:6617 with SMTP id
 cf40-20020a056902182800b00d0ed67d6617mr70431ybb.4.1692283541337; Thu, 17 Aug
 2023 07:45:41 -0700 (PDT)
Date:   Thu, 17 Aug 2023 07:45:39 -0700
In-Reply-To: <998ebc6b-4654-f0d3-dc49-b2208635db48@linux.intel.com>
Mime-Version: 1.0
References: <20230719024558.8539-1-guang.zeng@intel.com> <20230719024558.8539-3-guang.zeng@intel.com>
 <ZNwBeN8mGr1sJJ6i@google.com> <e2662efe-9c53-77de-836c-a29076d3ccdc@linux.intel.com>
 <ZNzfgxTnB6KYWENg@google.com> <998ebc6b-4654-f0d3-dc49-b2208635db48@linux.intel.com>
Message-ID: <ZN4ykwq11h6awR2k@google.com>
Subject: Re: [PATCH v2 2/8] KVM: x86: Use a new flag for branch instructions
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 17, 2023, Binbin Wu wrote:
>=20
>=20
> On 8/16/2023 10:38 PM, Sean Christopherson wrote:
> > On Wed, Aug 16, 2023, Binbin Wu wrote:
> > >=20
> > > On 8/16/2023 6:51 AM, Sean Christopherson wrote:
> > > > Rather than call out individual use case, I would simply state that=
 as of this
> > > > patch, X86EMUL_F_BRANCH and X86EMUL_F_FETCH are identical as far as=
 KVM is
> > > > concernered.  That let's the reader know that (a) there's no intend=
ed change in
> > > > behavior and (b) that the intent is to effectively split all consum=
ption of
> > > > X86EMUL_F_FETCH into (X86EMUL_F_FETCH | X86EMUL_F_BRANCH).
> > > How about this:
> > >=20
> > >  =C2=A0=C2=A0=C2=A0 KVM: x86: Use a new flag for branch targets
> > >=20
> > >  =C2=A0=C2=A0=C2=A0 Use the new flag X86EMUL_F_BRANCH instead of X86E=
MUL_F_FETCH in
> > > assign_eip()
> > >  =C2=A0=C2=A0=C2=A0 to distinguish instruction fetch and branch targe=
t computation for
> > > feature(s)
> > Just "features", i.e. no parentheses...
> >=20
> > >  =C2=A0=C2=A0=C2=A0 that handle differently on them.
> > ...and tack on ", e.g. LASS and LAM." at the end.
> OK, but only LASS here, since LAM only applies to addresses for data
> accesses, i.e, no need to distingush the two flag.

Oh, right.   Thanks!
