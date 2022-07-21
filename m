Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E657D161
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiGUQVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbiGUQVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:21:35 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875C918399
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:21:34 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f11so2285891plr.4
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=B5QADwm1IjojmIP5KhzAK+RFSkf1XxJ83WA0F0bHtjo=;
        b=iUUJ1Ha+14FXUJoXmObbgUmonhYR0mB4408FF/ScjresrnZaUIpq/j+K6Dzthg1ADe
         sKV0urwdg9XHOPe4H7iBH5oKYSPPiYLv5TfaJv6BPM+8YrQrWVzp/2wuMtBFiDXIIAtQ
         hC0665IlnL2ixOxsIsVzxJDTXoKZ2pFbMnWzChQCWTP1nIh3jO3ma6n28ek5Zp+FGOYQ
         IRD0p0cYR0tVxO9xgQu52295cbkmsFDs+6j9v9gEfVAM8OxtKqF4cTsDUPE2ZZ7+nA+r
         GA2LgVy+5QsITEoFqs7lfZhcWUMchdRKAX8RBshFLTZVTAOcUdUrSayIsx2QCroB1TV6
         odhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=B5QADwm1IjojmIP5KhzAK+RFSkf1XxJ83WA0F0bHtjo=;
        b=BlziTsYZ1F2JkPT7JzpR8auCFGslgnIXS9DVp0YrOL/NreEVSz/n1KOo9GdbJUdAXx
         egyWofoZUWDeg8HyQtsZGVuMGu+agaUxJx1eW6wOwr1y/XaUJmiFyTZ/IgxgLnZNuMdJ
         75LUrucgFdbec6R58Zv5I8nxzv80nvYizHnsMknfLO9KP/mmpQ2nTgxesK1+TgYIslB8
         QB8JceDnNh4GUI+KRE5RXsHJIsHFN5GcYBsh1oRXObvQdRk2Ast54QpxhXlesVKnqPQJ
         q5yt3r3JSa7yu+/ZJ4rBiwPRYozkKC4q1AwuDc6CGgfbPyn2MsuWPYUjZKoewpsYAoUJ
         m4WA==
X-Gm-Message-State: AJIora9WOFsW+RJGRQxnV/oifx+KA3a9hfFCB2z6LLiN6dXAc/LO2Vjb
        DF8pMiBrDl0kGG3DDcY7Ip5BGQ==
X-Google-Smtp-Source: AGRyM1uYJw8SiSBykSPdKMWwYiMI8y6/BXPB2OVNz12c04yXYZIYgKUchjjDsX68QiSfG0eluJFd2A==
X-Received: by 2002:a17:902:e74d:b0:16d:1e82:c8e6 with SMTP id p13-20020a170902e74d00b0016d1e82c8e6mr9653520plf.17.1658420493795;
        Thu, 21 Jul 2022 09:21:33 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id a12-20020aa795ac000000b0051be16492basm1987812pfk.195.2022.07.21.09.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 09:21:33 -0700 (PDT)
Date:   Thu, 21 Jul 2022 16:21:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [RFC PATCH v2 3/3] selftests: kvm/x86: Test the flags in MSR
 filtering / exiting
Message-ID: <Ytl9CaEZUKMug5oD@google.com>
References: <20220719234950.3612318-1-aaronlewis@google.com>
 <20220719234950.3612318-4-aaronlewis@google.com>
 <YtiOgtQy1bjL3VNX@google.com>
 <CAAAPnDEKS5hrunMg8Q5Gvt=bU81zZD6fMWsfqRJu029JXpvv1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAAPnDEKS5hrunMg8Q5Gvt=bU81zZD6fMWsfqRJu029JXpvv1w@mail.gmail.com>
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

On Thu, Jul 21, 2022, Aaron Lewis wrote:
> > > --- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> > > +++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> > > @@ -734,6 +734,99 @@ static void test_msr_permission_bitmap(void)
> > >       kvm_vm_free(vm);
> > >  }
> > >
> > > +static void test_results(int rc, const char *scmd, bool expected_success)
> >
> > Rather than pass in "success expected", pass in the actual value and the valid
> > mask.  Then you can spit out the problematic value in the assert and be kind to
> > future debuggers.
> >
> > And similarly, make the __vm_ioctl() call here instead of in the "caller" and name
> > this __test_ioctl() (rename as necessary, see below) to show it's relationship with
> > the macro.
> 
> The other comments look good.  I'll update.
> 
> This one is a bit tricky though.  I did originally have __vm_ioctl()
> in test_results() (or whatever name it will end up with), but the
> static assert in kvm_do_ioctl() gave me problems.  Unless I make
> test_results() a macro, I have to force cmd to a uint64_t or something
> other than a literal, then I get this:
> 
> include/kvm_util_base.h:190:39: error: expression in static assertion
> is not constant
> 190 |         static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) ==
> _IOC_SIZE(cmd), "");   \
>        |                                       ^
> include/kvm_util_base.h:213:9: note: in expansion of macro ‘kvm_do_ioctl’
> 213 |         kvm_do_ioctl((vm)->fd, cmd, arg);                       \
> 
> That's not the only problem.  In order to pass 'arg' in I would have
> to pass it as a void *, making sizeof(*arg) wrong.
> 
> Being that the ioctl call was the first thing I did in that function I
> opted to make it a part of test_ioctl() rather than making
> test_results() a macro.
> 
> If only C had templates :)

Eh, what C++ can do with templates, C can usually do with macros :-)

Sans backslashes, I think this can simply be:

#define test_user_exit_msr_ioctl(vm, cmd, arg, val, valid_mask)
({
	int r = __vm_ioctl(vm, cmd, arg);

	if (val & valid_mask)
		TEST_ASSERT(!r, KVM_IOCTL_ERROR(cmd, r));
	else
		TEST_ASSERT(r == -1 && errno == EINVAL,
			    "Wanted EINVAL with val = 0x%llx, got  rc: %i errno: %i (%s)",
			    val, r, errno,  strerror(errno))
})


It doesn't print "val" when success is expected, but I'm ok with that.  Though I
suspect that adding a common macro to print additional info on an unexpected
ioctl() result would be useful for other tests.
