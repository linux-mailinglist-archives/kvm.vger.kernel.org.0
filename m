Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35585430E7
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 22:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfFLURq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 16:17:46 -0400
Received: from mail-it1-f172.google.com ([209.85.166.172]:52580 "EHLO
        mail-it1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfFLURq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 16:17:46 -0400
Received: by mail-it1-f172.google.com with SMTP id l21so13016666ita.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 13:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=bmY5T6u/XiIXDzZdI8zSgN1e6W0hKMZOF3xTiGL2+dk=;
        b=gVxIvxKRfBEk5uE1jd5dsU5YPLseUm0ATyGN2trZ9/fWvT62a4lDxb91RgeC/DIEBU
         Ud6WZb1NoVoEeTnd+1GszKZTFKyARumGkKuUVVlQhMEdmuGbnlETMwKy/RBP0lygP3Ie
         GkpscyVvz4R0w7sNa5/Jc/tQ9Olj0T8wXFE/en/18t9ep2wgDITxH81P9UejxmoMio29
         VMsBl5abfqg8WLVzKdlp+IepHVyY2fYbSfLWZYcdHCYePZ767B947ZvbgogOtnGPg46u
         MByFtKUvobBHOQGJoeFUJP6GrCtu27jxXZ6MvAA4cOMaAnrh/7xSNo9PvuSdtzLhTb/X
         5W9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bmY5T6u/XiIXDzZdI8zSgN1e6W0hKMZOF3xTiGL2+dk=;
        b=OJjDpAHv4CXn+IE+cB7kE9St9GhkIHQFO33sPkVSkT9bq99vTPjJoeqgQI77EkfFLH
         xJalZyjpRr/zzqS0iJYNX9X70MhdyZnGgOigNf60qemqdzCADLVUpSYvndPYvbP98VFZ
         PAQ5ZeXkAhqid23sG9e6kAwb44t4Hh1+aQ/m9ZRGpg+AzYukIUZA1YtE6CqMY0LQ6C7u
         AoJ6qPXSfzet0HhNqKdQ6F+KF97oP3Z7nhsw6onlJoZNwd1rM0XwREP0n1uF7ajHa2dX
         rLz5NTlTDtwfyUz3MMD3wvaUZ9ns48K+8o0LfVOKtLW9r1NfrL17mqwnLidJI5d79G87
         84lQ==
X-Gm-Message-State: APjAAAWMZTkNN2nIN8ICqoZow5bTCFPsQz4ke2+cSFdaP40Sx1DeR5wu
        TLu8EbHZzNGdiLU3vGCqA0jp1SlJXefvIXkgfjERlkvN9gOcLw==
X-Google-Smtp-Source: APXvYqwyFVB0GZ8IFjV4KE5AAmfjni4EHuEkJjiqywk2B1nuZ/MwyQVxf+z83p9Wjz4vWl57qYMMaV8RyFCwuExq8pY=
X-Received: by 2002:a24:dd92:: with SMTP id t140mr762066itf.60.1560370664956;
 Wed, 12 Jun 2019 13:17:44 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 12 Jun 2019 13:17:33 -0700
Message-ID: <CALMp9eQ4k71ox=0xQKM+CfOkFe6Vqp+0znJ3Ju4ZmyL9fgjm=w@mail.gmail.com>
Subject: What's with all of the hardcoded instruction lengths in svm.c?
To:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take the following code in rdmsr_interception, for example.

svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;

Yes, the canonical rdmsr instruction is two bytes. However, there is
nothing in the architectural specification prohibiting useless or
redundant prefixes. So, for instance, 65 66 67 67 67 0f 32 is a
perfectly valid 7-byte rdmsr instruction.

It looks like this code was checked in with commit 6aa8b732ca01c
("kvm: userspace interface"), with nary a word of explanation.
