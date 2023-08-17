Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E022A780168
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 00:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355925AbjHQW5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 18:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355926AbjHQW4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 18:56:36 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B1C30C2
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 15:56:34 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id 71dfb90a1353d-48b2f5b9b08so98597e0c.2
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 15:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692312994; x=1692917794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BSLdEl6y6GOOfZPMbAm1X61Kn+8pfMiX9JSO1SZgo7o=;
        b=5NoykWtFZs/nE4I3lBUnYiw8vG/Lxi4lpTCwIXP9Vd9/i771DnYRDS2os0ZNipnaWb
         J/bV+lTxxD5zZ0tcihzv2ldNIqhf7I8rkyG8vB/xIdERHohsp4qlpS3Zg4OulgeAOkUY
         H1k4LA6D5Ik210rfMxa+bS/Ra9Wb2m81pwx1XoDYnPe0eMiF/Lvc4Y3PQl5OYEgEPkQp
         uNItNwqxL0QwwI0yS9YInv5XwOICS6srvCZH9HM1clWul02Rn0Dm7NkMQrnw8s1LW4d6
         HP9hdSNEuitv717sxOba6a4ZvRRH/74xm+2YPwWIHhAORW6Fdpspo69HaUCS21Hbf+9P
         kxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692312994; x=1692917794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BSLdEl6y6GOOfZPMbAm1X61Kn+8pfMiX9JSO1SZgo7o=;
        b=UnsXMQwHqDH7j7E7dpNi3q0o1okm3GjtnIoo8Vra095S3shQ6gHx8Ji1jbmOcsuEYY
         u7BYCzE5y4ZGPF8tcRVQv3k9BHFwVDtLp2fZQ4pmCN8h8de6JTazVd4HONXTY6tYA+w7
         HX16/VizA8ovftX7ECYL9fp4/oyFSfwXd7Xn1MKQcSSJwSllcxVlKj+3m542FbWDhQoF
         yohXzH3c73Yz8BQzt5HWcl2L6ejYSLiE2ZqB7J9PgnvvyrnWauydlF4SSqyvrIAxawoV
         DyKv1WtmXdL/iiaoq1ZaxYK0E4kRvIXT5guo+8LOAgFxYve6R0inh38D98sE7/uJDZAp
         xIOw==
X-Gm-Message-State: AOJu0YzNlUjAR9Hw8ZJLDR76weKrxCG7GM0pkA+BUv3vHAsZHdD8hVHr
        9Awqdo7Lg9qQoab3Ba0pEJo8hUYwREWEVLqks/MEzMXZ/ChCXja1UIJPDw==
X-Google-Smtp-Source: AGHT+IGkWl3rmU94+T9hxKzfbEmuqRQAzMVxf+uGv14pXl2VnZW9ME0ok1IGyiWl2bNae6I1GG4wPagS3SshCxRT+nY=
X-Received: by 2002:a1f:5f05:0:b0:487:1774:405e with SMTP id
 t5-20020a1f5f05000000b004871774405emr1366806vkb.11.1692312993986; Thu, 17 Aug
 2023 15:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com>
In-Reply-To: <ZIn6VQSebTRN1jtX@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 17 Aug 2023 15:55:58 -0700
Message-ID: <CAF7b7mrDt6sPQiTenSiqTOHORo1TSPhjSC-tt8fJtuq55B86kg@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

Documentation update for KVM_CAP_MEMORY_FAULT_INFO

> KVM_CAP_MEMORY_FAULT_INFO
> -------------------------------------------

Old:
> -The presence of this capability indicates that KVM_RUN may annotate EFAU=
LTs
> -returned by KVM_RUN in response to failed vCPU guest memory accesses whi=
ch
> -userspace may be able to resolve.

New:
> +The presence of this capability indicates that KVM_RUN may fill
> +kvm_run.memory_fault in response to failed guest memory accesses in a vC=
PU
> +context.

On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> (B) is the trickiest to defend against in the kernel, but as I mentioned =
in earlier
> versions of this series, userspace needs to guard against a vCPU getting =
stuck in
> an infinite fault anyways, so I'm not _that_ concerned with figuring out =
a way to
> address this in the kernel.  KVM's documentation should strongly encourag=
e userspace
> to take action if KVM repeatedly exits with the same info over and over, =
but beyond
> that I think anything else is nice to have, not mandatory.

In response to that, I've added the following bit as well:

+Note: Userspaces which attempt to resolve memory faults so that they can r=
etry
+KVM_RUN are encouraged to guard against repeatedly receiving the same
+error/annotated fault.
