Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3202722CDB
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbjFEQma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjFEQm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:42:29 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465C5D9
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 09:42:28 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id 71dfb90a1353d-461b6c85a28so1125993e0c.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685983347; x=1688575347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7FCKK87DvKxeumyy9SDd2/SDnDekXDap0QpJp+wkJ0=;
        b=cWdp1XmK5svgOe4l0TjsaQ8jjivdFIm3dMhGNN479CW6NPGgwdIvsYcFL6mf501/0I
         trdXpgFP9MvAvz8docIpatqv/zl4OinM66kgjuqwoQnJX0IGuVQmhq+c8oRuCwfA1Xgs
         ax2TYDkeGC1/Yl5N38C3YTrAh1TWvKbQ0oKe2hHfgHgvxvNMM7nnY5Hakew+2s7isuuO
         7iIg7aIlSMz6+sX2eTUCxhMiux14eD271uYOeUvCiBawAXyqy3ptyJOGBfiRMiKdptG+
         oHwdZf5luJuYlTih6+rbnpEIHsXMXygRssPbxJL4PaxxWAGldQEvSD/Fs/bhKX3aZnke
         oZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685983347; x=1688575347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7FCKK87DvKxeumyy9SDd2/SDnDekXDap0QpJp+wkJ0=;
        b=X4kwhK6/Vh35DXZFcPs0qgQAgRovCzInt7PVgkLOWhwvHE8BSWmBmET5w6HrvJNloc
         bFCG174HHc1prtFyGynPFcSUcZUPmXRBtGFVlZkp8pAHpmT44ymvb867GssUjQk7EGUS
         wJYZ1h6qTmZlz2xc3BAblUmqfHJ0bsxDbzpUhwryYrjFBv4gdmZgdWvfEu1/HbhLO6so
         ST0AMMTlFfV2uwmOOx8xEqQ1kDCayOTQQXEx/xVqq9IQ28t4ZKpAk6v4OypFSiFO+9WA
         eIpwwzGqLyfjdjpeu23cUY2norY/OF22LTJFdreAAQFHC8LlT/3lI5siIkl4jPJ/WCFe
         vHDw==
X-Gm-Message-State: AC+VfDzsO7ngkor+6zNvC9OZuKK/WGPxKSjR3Qp1SPONv8sRcXZMX8Kf
        dwnmnfoJbEUCAU0gaaFjKXqGCzLFf1snG8N2QAeuxQ==
X-Google-Smtp-Source: ACHHUZ5aDqxqtFCwzCxAXkm7KOLQsjJTn5mGkQBeDWdNKAW515azAvtnqClsKAZnwGpKwxavXkJhAvvMTQivl+YRx0k=
X-Received: by 2002:a1f:48c1:0:b0:461:37d:dd3e with SMTP id
 v184-20020a1f48c1000000b00461037ddd3emr3540042vka.15.1685983346888; Mon, 05
 Jun 2023 09:42:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-3-amoorthy@google.com>
 <20230602203031.GK1234772@ls.amr.corp.intel.com>
In-Reply-To: <20230602203031.GK1234772@ls.amr.corp.intel.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 5 Jun 2023 09:41:48 -0700
Message-ID: <CAF7b7mp2kccagOipwZ_d+n6KEjY5zu=k3XVq0wZJ_GHvMqWqtg@mail.gmail.com>
Subject: Re: [PATCH v4 02/16] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com
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

On Fri, Jun 2, 2023 at 1:30=E2=80=AFPM Isaku Yamahata <isaku.yamahata@gmail=
.com> wrote:
>
> As vmx code uses KVM_EXIT_UNKNOWN with hardware_exit_reason=3Dexit reason=
,
> Can we initialize hardware_exit_reason to -1.
> It's just in case.

Will do
