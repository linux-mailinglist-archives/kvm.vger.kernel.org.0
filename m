Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A473C6D2054
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 14:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCaMcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 08:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjCaMcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 08:32:21 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EC420322;
        Fri, 31 Mar 2023 05:32:13 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y20so28701885lfj.2;
        Fri, 31 Mar 2023 05:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680265931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4KTJSn8H2uB3vfjjc3uadlsM15f3kbQVGyII0+t/LEI=;
        b=QD7WZmmZFrod6yoS7XIZqmHoij1p+/FnZDtyTewCqJtKLBHpesNP2T6jCg+PR3I+8K
         +i/SQVdPyh5dkNoxURbgtJ+N217ohEJRtDop/unOriovtyK3Q1+NznEJmjKVLNye0RtP
         TVHB1veuODw/isGXnIejoTLai8xDaJ3CYaj2705V1qazaU8DCKIrFJWC73L8faON1tdm
         nacW2wR1LYEtFjcGH68Cncb70AUQSusZca2le0uTX0L/JstBPZSX87Z9KdCjKxrRyiOf
         hzwrcVmmQqBtth+Jrb3UvHS6uPATZsmPQeU1h7sAD52RU92bV9XyFWUpJLfxGcl1y9YZ
         lbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680265931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KTJSn8H2uB3vfjjc3uadlsM15f3kbQVGyII0+t/LEI=;
        b=pNrnUocn65j5hA6Cu3j94rBeXb5OK9kzm9DJ+slakQjQ6NWggJSBnlZs/HxDc4n9bX
         y/Fv1/Fl9kMxiMtx514l5xPSYWDaIAhtcWQoWs+KEX1ugd01uc7Pzhgvg/lcB569fh6A
         54CvNlc8FwLN4ZeLiT2DUO47bEUnkFOX5oNHvuTHbjnmgqOwXQgbNn1hQsXHZbkr/SUy
         O2v5vYPhxKkYuoU3CCKmus+POAB5woUH5O8XOMHd4GbZUNAACSCf/gaFz/bNmDRpMADg
         hxJ0xmAKQeDpXjoyQELN/QZ1jHlxvixoniKvF3PH98iuK1srqSwbKBalCQhQgIMfUrLC
         /WPg==
X-Gm-Message-State: AAQBX9dVkPC8itFPNyxaIf9Yu+vZxGvP8m0aw8dZKJA7pypCF7MynoIR
        0DK9HbC+y3K5g9LTw1d6lEI=
X-Google-Smtp-Source: AKy350bi/1sg0cnb5OcjJ/cTjCDoqHFGrnq1llQWEaltCKfDWpiDoPSKckyey3/WflsAFNaLe1vG1w==
X-Received: by 2002:ac2:4946:0:b0:4dc:807a:d137 with SMTP id o6-20020ac24946000000b004dc807ad137mr1455128lfi.4.1680265931481;
        Fri, 31 Mar 2023 05:32:11 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id b4-20020ac25e84000000b004b4b600c093sm361849lfq.92.2023.03.31.05.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 05:32:11 -0700 (PDT)
Date:   Fri, 31 Mar 2023 15:31:07 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 016/113] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Message-ID: <20230331153107.0000029d@gmail.com>
In-Reply-To: <fc642000-7db8-9944-e57e-db54f0d1336d@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <cb0ae8b4941aaa45e1e5856dde644f9b2f53d9a6.1678643052.git.isaku.yamahata@intel.com>
        <20230325104306.00004585@gmail.com>
        <fc642000-7db8-9944-e57e-db54f0d1336d@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 31 Mar 2023 14:59:18 +0800
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 3/25/2023 4:43 PM, Zhi Wang wrote:
> > On Sun, 12 Mar 2023 10:55:40 -0700
> > isaku.yamahata@intel.com  wrote:
> > 
> > Does this have to be a new generic ioctl with a dedicated new x86_ops? SNP
> > does not use it at all and all the system-scoped ioctl of SNP going through
> > the CCP driver. So getting system-scope information of TDX/SNP will end up
> > differently.
> > 
> > Any thought, Sean? Moving getting SNP system-wide information to
> > KVM dev ioctl seems not ideal and TDX does not have a dedicated driver like
> > CCP. Maybe make this ioctl TDX-specific? KVM_TDX_DEV_OP?
> 
> What's the real different of it? For me, it's just renaming 
> KVM_MEMORY_ENCRYPT_OP to KVM_TDX_DEV_OP and maybe add some error message 
> if the IOCTL is issued for AMD plaform.
> 

Hi:

The ioctl is the API for the userspace. The purpose is to be orthogonal,
avoid confusion and reflect its nature. A "generic" name with only one
implementation is fine in the early design. But if the other implementation
at the same level is pretty sure not going to use it, then the abstraction,
which is only abstracted for one implementation, is just confusing.

The possible strategies are:

1) Re-factor the other implementation to fit the current abstraction.
2) Give up the abstraction. Go "specific".

For 1), it seems not realistic due to the efforts of re-factoring the SEV
driver.

For 2), there can be several ways: a. renaming it, let the name reflect
its nature. IMO, KVM_TDX_DEV_OP is not ideal as well, but I don't have a
better one. b. moving it to a proper layer of the implementation. But
it is also not realistic to have a "TDX" driver because of it. That's why
I am torn here. 
