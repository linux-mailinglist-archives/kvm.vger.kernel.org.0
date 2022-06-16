Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56BA454E7FD
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378348AbiFPQqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 12:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiFPQp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 12:45:56 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9634C7B9
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 09:44:57 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d13so1691298plh.13
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 09:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xG1JxbDKxb01OfIHZiWzJ8dX+sp4j/hRW+fJhSLHjUM=;
        b=b4rY5tlFpOatFB3vmE9a2jj1fFVMclIEwyq0WxVDdILA+fTeqUJYGA5QHDQVVVil+d
         aE5PIwuqCJDADBd9bP2hg8VoxOCkrp0XkzZ+Okshjc5L5rVDU84v3rYBqKI27xRyn+4G
         53ZStZx2xGi01pKf9bJ/2syyif9NbYH/fCzTMiTCXO9EnSvJJhol7+yPswpzHVD1HN75
         o9gH5yqJKQSDpJaQioFHhRBBqco2gW/UOx+d/kqqzmFGRFpZzfaxg/+8t0sBT7DtF3jb
         kU81KAR1rBOj+zaH9JKC5dLIgUOUI1TJGUJZLIaK4CPwXIIsn473Kw5qc+3L7e3B+8lI
         h6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xG1JxbDKxb01OfIHZiWzJ8dX+sp4j/hRW+fJhSLHjUM=;
        b=HNFgy8qpg2qQnI/EXOcvU6hMfGfcch/rQ/UA/0lSeG6m/UwzxdDQjrqrQUFl4/rG4H
         UKm1qf2bgmjsVg+p/4NMN0SKFs6IR6XjbRQlncuH5BC/hjvyDrhnT/JF9kTpVR+RFOhJ
         w1VQnOehfP4B3lHKXCPF/WA7IzbNmEkNVqmaZpOH/rIiAlu6WBQCtljKqJ2dllIftUm1
         UXE8icuPjCxjZ6M4OOeyBauQpbJNJ8adeY/iqgW4eiEtSSWPBSzVSmxUfA00PZMi6Da+
         ae5RIpSduBf1BxtXHbcj/KCS55P5pc/qBZ5LWXpp7enRPDtLyDj3RPTixVtpMuoKEFCt
         pstg==
X-Gm-Message-State: AJIora9+y0FxtSPNUKrmiUNn1LedII4zW+fA3qcFCAoIjD5PWOUNCQoW
        eNeIZC4JZBoiniYdebR3lfExJg==
X-Google-Smtp-Source: AGRyM1vosOIKitlvNBM5Iykv0v1VUHnUQBJH/nVCh/M4Oe/f0ApTqCG4ggZDu8FbdFoccbhJElwYJg==
X-Received: by 2002:a17:902:ce8d:b0:169:c18:a322 with SMTP id f13-20020a170902ce8d00b001690c18a322mr2165443plg.51.1655397896578;
        Thu, 16 Jun 2022 09:44:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id c11-20020a621c0b000000b0051ba303f1c0sm2001278pfc.127.2022.06.16.09.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 09:44:56 -0700 (PDT)
Date:   Thu, 16 Jun 2022 16:44:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, marcorr@google.com, zxwang42@gmail.com,
        erdemaktas@google.com, rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 02/11] x86: Move ap_init() to smp.c
Message-ID: <YqteBKYywG3N9ipt@google.com>
References: <20220426114352.1262-1-varad.gautam@suse.com>
 <20220426114352.1262-3-varad.gautam@suse.com>
 <YqpPmz2SUP5nsUL+@google.com>
 <20220616115646.7u2bgbyppgzjivk6@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616115646.7u2bgbyppgzjivk6@gator>
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

On Thu, Jun 16, 2022, Andrew Jones wrote:
> On Wed, Jun 15, 2022 at 09:31:07PM +0000, Sean Christopherson wrote:
> > On Tue, Apr 26, 2022, Varad Gautam wrote:
> > > +	printf("smp: waiting for %d APs\n", _cpu_count - 1);
> > 
> > Oof, this breaks run_test.sh / runtime.bash.  runtime.bash has a godawful hack
> > to detect that dummy.efi ran cleanly; it looks for "enabling apic" as the last
> > line to detect success.  I'll add a patch to fix this by having dummy.c print an
> > explicit magic string, e.g. Dummy Hello World!.
> >
> 
> powerpc and s390x always exit with
> 
>  printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> 
> It's because they can only exit with exit code zero, but maybe it's worth
> adopting the same line and format for EFI tests?

Honestly, I'd prefer using truly magic string in dummy.c for the probing code so
that it's super obvious that there's meaning in the string.
