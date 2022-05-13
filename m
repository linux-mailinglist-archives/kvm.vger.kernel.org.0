Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAFD525B5C
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 08:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377321AbiEMGQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 02:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377404AbiEMGQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 02:16:02 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200852734DA
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 23:15:18 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id c62so7387294vsc.10
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 23:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=4pVDn2OJ7GUsmOCrQu105M1wbXVuykBRE38Q67/5bgM=;
        b=esftJ4JpTM8g5IYslBctTjq6KqHkG78O4yzVMkGpCJ0SS26+aWuylllPqNa/VS8xW1
         onlhHEmoTkL7V2JJEu1Zmd3cYcE/stccmNjRHXn7phKjfZfCwQBh5o24mEtUA3sB7FjI
         R1cqZQnIGZBkO+qZXuq/sth76iEZgBqw3a8LbGul0BcQcddpFP0fLKCRLT68RLpdx5iz
         R0n22rqIBCLG46R4ZLp51dbdHfWPJlwN/jxNlkNdhX7ynZ+BU/3vS4254ME0pM+j/0Dh
         I5jW5/X0Y6ZPkcdNUXp4ZlXUZVJZCzmxCAPwps6Al2qGSq5zCRYN2RW0Cjl8A6/lXJqH
         V/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=4pVDn2OJ7GUsmOCrQu105M1wbXVuykBRE38Q67/5bgM=;
        b=jfK4LhJA5Or8mMGQo/JMLKjmRQbzv9cT+1MMhR9VWjaW7+MRTPoozGwz1aOCam7mpI
         MIxxwHbRDbz9Ac2++WR+VtFn08E1bY30m/1kEFQmVGgJWLkx2276o0EI7Jc60MyZ1NGS
         kxfqxEKGWitemvptqC3jGkbT0t3mQk8FGtgs8MrJTEUZZO0DQd6pHO5CZ+GyQd9YOcj+
         jbmKxwHHhJZsTkuxBk1zced9Sx/ntg8TK7q4bLoDi20G6fYy9XHRd2fWPDqphzS2a8Do
         qOmPgEKQjTZ5JW9ObpQpm6MWqbPyrEuEQpTUJcBH3StD3V3l4CSR1pnUt06KRODlVAFZ
         UiAA==
X-Gm-Message-State: AOAM530flmZfo0OxcS+8FiySVtET2IiqG71bGblVzgGg6fZxUaTf4+KL
        1HQqzviHqyEVuFv3QtF6NbyGzSzpG3qQdiioOCOJZTe2XIM=
X-Google-Smtp-Source: ABdhPJz9caTbGJBLr1BXTXa8+QebGqP+bzrM0Qc4QOMbiuNH1fWJh/BP3KiIpEKVJPy5KvxuLXhakavHmlLeNHBfItY=
X-Received: by 2002:a67:e899:0:b0:32c:db20:e21b with SMTP id
 x25-20020a67e899000000b0032cdb20e21bmr1811281vsn.36.1652422517185; Thu, 12
 May 2022 23:15:17 -0700 (PDT)
MIME-Version: 1.0
From:   Florent Carli <fcarli@gmail.com>
Date:   Fri, 13 May 2022 08:15:06 +0200
Message-ID: <CAJuRqcC0Z-wbAhb39ofKPstgbg+ZmsT8eFivWEr-hZY64_A1xA@mail.gmail.com>
Subject: Cyclictest with small interval in guest makes host cpu go very high
To:     kvm@vger.kernel.org
Cc:     nsaenzju@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

When I run a cyclictest with a small interval in a guest, even though
the guest's cpu load is small (2-3%) the host qemu-system thread is
showing 100% cpu utilization, almost all of it being "system/kernel".
There seems to be a threshold effect:
- on my system an interval of 220us creates no problem (host
qemu-system thread is 4% user and 1% system)
- an interval of 210us shows the host qemu-system thread at 4% user
and 50% system)
- an interval of 200us makes the host qemu-system thread at 4% user
and 95% system

Those threshold values are probably not universal...

I'm using kvm with qemu on x86-64, and this issue seems easily
reproducible (yocto with a 5.15rt kernel, debian stable with a 5.10rt
kernel, or a non-rt 5.10 or a backported 5.16rt kernel, etc.). I
reproduced this issue on a debian stable non-RT kernel to be sure the
problem was not due to preempt-rt.
My cmdlines for host and guest are very basic: ipv6.disable=1 efi=runtime
Vcpupinning does not change the outcome.

I'd love to understand the cause of this behavior and if there's
something to be done to solve this.
Thanks a lot.

Florent.
