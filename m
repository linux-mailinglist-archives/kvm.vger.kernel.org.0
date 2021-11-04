Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F34444D5A
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 03:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhKDCnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 22:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhKDCnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 22:43:19 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA112C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 19:40:41 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e65so4119653pgc.5
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 19:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l1LBkVxSub6LJ5OnLwtZ2Go/f73Tx/9aZenvySQfHeI=;
        b=ZW8TrfFoTH/tYASAAkeV0eDaMdGL/LctDxidEfV+xRUTyZ7KwSxyi9DKFFPXnB2FlC
         A8nkvWWExDP3moWXZOmtv0Mzi0B2KKbU/alkNtxkfSWl53CI7HNkvCgVfPJGPT1jq/7k
         uK3TOZvwYLbnPkDd5WYsiH4a0TYXOrk7JONuOJO8yCBh316ScLDOZ7sxmEeg7I9/wKYs
         /7xZtZbZ41/h8OweuhfMUXyXw074W/J06ZCLcVTR/XMjTFFRPaW63EkLQcFMrJwnziyh
         FseFp37H5yPIjowS70gHcwa0IocAqPcfoJvJvhG+kyIma5tVLbiwGbWe/qRFC1KJoyHt
         XMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l1LBkVxSub6LJ5OnLwtZ2Go/f73Tx/9aZenvySQfHeI=;
        b=1ijN8zxHhFjcHoeKGTJmAHFR7dUt6Jf5uBXv3Gw1eoixV95Wiif3eRL8STo7JSAY+e
         O8OnMdi+K+1EPF8aIduz6dcOvoFdZu9qkukyYIWIo0QlPT0OMCV2GfCoI414d5eMVW/c
         xNOdF6hOMaaWLYX4UH7Kef3wcBtDnNx5brMtaeAvlMzPCE7b7xAf7YaYKf6pkctx3wQF
         MTmwK249H83ER5SZcovXOU8IR+2jer5S3XDqzyeNxIvN/dclvOID4ZiX8JsMKprq+RPC
         wmbC8/Ycv6Y8uMlBGZ4vA9XMjw6QyOPqkN5t8wC7a/FXlIACrq5kwxc5mBml9bA/5Q9c
         ci9A==
X-Gm-Message-State: AOAM5311hlrwyhecseM0zhnuHB++fKYOg6CFIp4fnjTiPNfWY3JI0dZb
        IlW3iBGDxrrSF+0fuRIatWTNCaSNiJn+Gp21rMQilA==
X-Google-Smtp-Source: ABdhPJzAFkFqwjuIjHc0h9oKGkvOHRgsFxGKfJBRuHvvwWYY2QLB2+GCOWAkaMHse2lngZcp/lkw0B+Edbhnyr1mOCI=
X-Received: by 2002:a63:c158:: with SMTP id p24mr5456974pgi.53.1635993641104;
 Wed, 03 Nov 2021 19:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com> <20211102094651.2071532-2-oupton@google.com>
In-Reply-To: <20211102094651.2071532-2-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 3 Nov 2021 19:40:25 -0700
Message-ID: <CAAeT=FwDep0irwYauX8kyRKfOOtdpqm_CAntDu_COYa6zJAvDg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
>
> Any valid implementation of the architecture should generate an
> undefined exception for writes to a read-only register, such as
> OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
> behavior.
>
> Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
> write ever traps to EL2, inject an undef into the guest and print a
> warning.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji
