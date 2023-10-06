Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2B77BB0A2
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 06:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjJFEAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 00:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjJFEAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 00:00:17 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CACFDB
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 21:00:15 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so8039a12.0
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 21:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696564814; x=1697169614; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZZW7wLLeLb34Qnv/J0ZlasDNqG3WN41dPobi0oQZ7xM=;
        b=IlLCFigEm9H15bedunvsQ2BcQv5dQCgGWHBsUPeyrhGKHR6gywuUvM+XRsME34YGjJ
         WS8sgyBqtCQLh1w7A8yK6g8fN4ZNkCmAYb3LqrJTqfQRHs4kqOnwugME8ZxY6rQlAK55
         lcPLdGqqiWUczlMuwDUoqxdWHQxOtVleeFJXfZZVu0c/0ZjNw5LSXP1OSelJuevtmsOL
         ej4NjJskvwNlXT/+EYtPwji6PDKeY8WmP+Beuhw71bvefgBKJhOGApQ8PjJKQO1G6Vcx
         ZZhO6voc051lAqVBRMlLTXVtJKCUJUvbfYAGkuaiTEInRejt6Ai3Rbi0MJmAkHALH+ji
         IWGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696564814; x=1697169614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZZW7wLLeLb34Qnv/J0ZlasDNqG3WN41dPobi0oQZ7xM=;
        b=C+FGyhVj+nGlzJfDj91NvA6KVqh+UiF9UwAiAvesGMRXqohAKLyV7zI/jjQAfeo3GP
         ut/63PnIcLkq198GOibGjgrt5BtfPbPfflmAAKoFcayHVO/eTT4iecKRsoicVjk8dbpl
         m6kV36IC3Jjh6txMybA8TiEx7HJnhTC4RWfmyobunNcuYNN28hS2G1dHwg7kdzg3BWnw
         uEnyD/tZkiwY1nOi+94EOfDrG4gY+/1rB4ukj6BU909JKpXPYhJoLHELKByILUhfHbs6
         sa0LDL4v9//7DKHNcWFFAJ4N+vcXh27Z60kBvzoOvCMOxAJRxgrNfHudWpidhciuGOBO
         6Zjw==
X-Gm-Message-State: AOJu0YyXpK5t+eIlvHbSL2TQCUTh5/BKmzmqr9/JsxuFHvAA5/g8epXP
        mww09m106fcnvzpQvMByJWJDttVDLWvECUq4ZM/XRA==
X-Google-Smtp-Source: AGHT+IH4SIUVGI3KGt7mwMvudtStJhhMpYlc7E1m92+OpTa+leCV+NMXVWk40ravIkYX8f2EdbDqmfyMUvWN/CQNx64=
X-Received: by 2002:a05:6402:d4b:b0:53a:ff83:6123 with SMTP id
 ec11-20020a0564020d4b00b0053aff836123mr25351edb.3.1696564813804; Thu, 05 Oct
 2023 21:00:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230929230246.1954854-1-jmattson@google.com> <20230929230246.1954854-4-jmattson@google.com>
 <ZR-CmoacxFxkqZ6Z@google.com>
In-Reply-To: <ZR-CmoacxFxkqZ6Z@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Oct 2023 20:59:57 -0700
Message-ID: <CALMp9eRdMagNuJEPcqoUTDCuoN6xDpqLa+DA=oOZd6EjdQbgLQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] KVM: selftests: Test behavior of HWCR
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 5, 2023 at 8:44=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:

> If you've no objections, I'll apply the changes as below:
Go for it.
