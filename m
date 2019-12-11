Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8CBA11BBBB
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 19:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbfLKS2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 13:28:08 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46490 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730255AbfLKS2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 13:28:08 -0500
Received: by mail-io1-f65.google.com with SMTP id t26so12277661ioi.13
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GYZ+lGswFVXkExunAAAaOydIGqZJAHmJZ1GU8MypIx8=;
        b=YgOzV4v6I/TJVJydU7kTxVhF0VMLBMt2iNdLA+J1hNO6gC79rsTSsyFWoBw6gMfalQ
         jpz8UmB5Ox1hpBkwq/d5lES/48ikNJgOpc0sq6kUr0dcFaX5KyrXM1n1CPCxuMQmEDdF
         3Z7w09S39qzud1kYHF4BXd0Lo3dWITtHys7ilImYhq601hu7LNc2r6nhX/rRIceQFEP5
         1VY4h1GZsm/4GtPXsbWOCrcfTnOZlhQ1NH/FEkDjWWcOTFWnrxu1ioaPwIVlzjS53fKh
         f3jAWpXen+JUdXQ0LDpScWpevyZbsFXNnrDfH2y+9sw+YQURKrXTJJ56cWRLir8caxGV
         y9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GYZ+lGswFVXkExunAAAaOydIGqZJAHmJZ1GU8MypIx8=;
        b=L+CAwG9Tj5+oOzE+2dKJvlf6DCFpVaFAXs37Wo75TX5zhyqgTQfOkHN37JmgqyIeZX
         zzGPoSE5fhjmuOWVRy7D76vUyCBKlwPtzUabEGUxtM/I6fHax2b1tr0dZPY8kn+hfoW7
         dt7xjWPSfR3bjWOdyO8Iw0XFZ9j3MyS50NteTTybUfWtcqR3Fxk5JegVwqsRZvh8s2UG
         sWf//Ydu7NCWwaGrXq4DURNAWcNng8ow4bqJdR/dfX8I5jMLZCV6um5CUuZrxfVapz3/
         gic/U4JM7Fsls7OPh/4QjSKHGZsTzFqDIik0+/fMNWmsU6wCun6YWjNWUp2G9TCEyA4D
         PxeQ==
X-Gm-Message-State: APjAAAUz6kK3TNIAJdka7NM5uT+UiUVFXZOf+pP5vBcf+HPU5pnU7ssW
        MvSLuqk3ct1+RhbgBqJjE38C57hMcqKpilFx7HD7Lg==
X-Google-Smtp-Source: APXvYqxIDlpEs2zoJLhRiXAXqzWo0oO6DflPW5rIoWl9fbpISlPNO+TX2x2qqejGkIbmidkvc94EXMb/3GXV1Hu5hYQ=
X-Received: by 2002:a6b:3b49:: with SMTP id i70mr3977659ioa.108.1576088887157;
 Wed, 11 Dec 2019 10:28:07 -0800 (PST)
MIME-Version: 1.0
References: <20191211175822.1925-1-sean.j.christopherson@intel.com> <20191211175822.1925-3-sean.j.christopherson@intel.com>
In-Reply-To: <20191211175822.1925-3-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 11 Dec 2019 10:27:56 -0800
Message-ID: <CALMp9eTqtTRgQZaCdbkEkL6bChCTOgVPgbYTjBi5iOqsTn4r-Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Refactor and rename bit() to feature_bit() macro
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 9:58 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Rename bit() to __feature_bit() to give it a more descriptive name, and
> add a macro, feature_bit(), to stuff the X68_FEATURE_ prefix to keep
> line lengths manageable for code that hardcodes the bit to be retrieved.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
