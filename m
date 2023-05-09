Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B846FBDC1
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 05:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbjEIDqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 23:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbjEIDqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 23:46:06 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4893C24
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 20:46:04 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-559e2051d05so77326177b3.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 20:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683603964; x=1686195964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=heI6wD+fRYtkZA7vvjU6+YVyZT4dFVGT3j8tdiHIFbk=;
        b=WVVeeXL+crNCpKv0OvJoozBZPP1RrEdHMojK0ZVf+NV5Unc7dqSTg1Rh5DD/EXHV/6
         Hbtn1iwbMcKJ0Q+p66hu3AQ5nyMMisv3ORTVS73CxwjNKSo/dAb9Ei5ielbuaETHed1J
         zlJwTCPEDzwA5wubx7F5QqSC8OsiebANCQWpNuI836b0doLi1qrIKy60/JxJW4LqQZZH
         WO0T+T+RnIYQV5JXlHY322CB0voYnpHvn2Q0M+3bxsrvqwXB0TLJ7aZEdpdQIJMFEM/k
         M18q4vHN5viXsYYGJ/Vr66+vmM5PzPu+7CcyWyXahpYY4uswv7oZ7pPiTUGgk1P/u3tB
         re3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683603964; x=1686195964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=heI6wD+fRYtkZA7vvjU6+YVyZT4dFVGT3j8tdiHIFbk=;
        b=YWiNoAH3a8xPKOeDoLZq7WbjrutjyuGr3F6nDFQiDtr4odB7WxLIoWQ46eTduA3aLc
         OCQofAV0nJrrbW6sc47CkfeI7nTBUOW3ovYTRIBgJQ9PcdT82bDLXo+wgtYhxrDTKrUI
         1xWc02huhRrX4sW/HvRbyZtntnS5sr3RGB1vbFh8yDphDHLB0fQa97ttw0ksTQ4S4OPh
         m8sADUh+cawtkspMUNHudJvbr8ddTuWQkd+OHsoRqZiwACXlsHfk9QtSbf8nhhZpMsqu
         J+UL0uoe/+g4fj24SGoUkq/anZ13+RCEURMN3X60HBgnMXTKARHHuDLCtSUhrJez7wJF
         E+Lw==
X-Gm-Message-State: AC+VfDwLaSmimQJRBQx11u5edFKvsuYWQufoRDjd1JiALWaK8LPOGR1v
        tHiTQAaQhH+YSIf4wwnCH7zd0erOXU2kc15NLRSZ/w==
X-Google-Smtp-Source: ACHHUZ6BXIumyb22hMEKrqwVERlTg3Gi82E1Wx1OzLAKN+UGFPvJGZZNrhiqWcKABGepS/mm1xwsv8n49RNf1H7czak=
X-Received: by 2002:a25:20d:0:b0:b9e:33a3:f8b4 with SMTP id
 13-20020a25020d000000b00b9e33a3f8b4mr12510089ybc.48.1683603963978; Mon, 08
 May 2023 20:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230509032348.1153070-1-mizhang@google.com>
In-Reply-To: <20230509032348.1153070-1-mizhang@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 8 May 2023 20:45:27 -0700
Message-ID: <CAL715WJJHqZcFURC1h2qa0yyH-cK-T1wxuYnBN7fcVB67kMmbw@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, May 8, 2023 at 8:23=E2=80=AFPM Mingwei Zhang <mizhang@google.com> w=
rote:
>
> Add MSR_IA32_TSX_CTRL into msrs_to_save[] to explicitly tell userspace to
> save/restore the register value during migration. Missing this may cause
> userspace that relies on KVM ioctl(KVM_GET_MSR_INDEX_LIST) fail to port t=
he
> value to the target VM.
>
> In addition, there is no need to add MSR_IA32_TSX_CTRL when
> ARCH_CAP_TSX_CTRL_MSR is not supported in kvm_get_arch_capabilities(). So
> add the checking in kvm_probe_msr_to_save().
>
> Fixes: c11f83e0626b ("KVM: vmx: implement MSR_IA32_TSX_CTRL disable RTM f=
unctionality")
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---

Sign... missed the following two Reviewed-by...

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

Since this is probably the final version, I hope Sean or Paolo would
help add them up before merging it. Appreciate your help. Thanks.

-Mingwei
