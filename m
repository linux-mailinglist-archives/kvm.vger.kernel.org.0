Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDC6A29BC
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 00:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfH2W0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 18:26:43 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41025 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbfH2W0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 18:26:43 -0400
Received: by mail-io1-f66.google.com with SMTP id j5so10124222ioj.8
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 15:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IpwpqDWjhxEMVpoUdMdeqgzNThLAZEsluQN2pEZc6og=;
        b=Y3fveE/1qfos52sbSKcnqg6RwZE2mnIHtFTRTL9ZZ9WthTKUL9Sa5vNalNzFagVSrj
         VR1zv2W2Zb4t1PYdXEZAlvTOj4Habg2ZzgUJP830f2M2mFfI1S84bVZcAY8d+7J0XbD0
         ntY5/ucYkRkaKykostZ85wKETvylp6fRtcGAiia5XfiiAEEQPDrV/NetyfF5CUAfbyE1
         lDl044mdDbG8Jg8UEHe1Al9PjMhjFfHQfG/j23GeR02QGfe9F/NrRZ3IH1m7S79dUiH5
         ZBXW/D2NeVLdkKn6RIdN+9ofvO+lUfKAX1dnmqVaNT6dNM0wXfjK/oZmoMl+cMRACHEy
         GCOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IpwpqDWjhxEMVpoUdMdeqgzNThLAZEsluQN2pEZc6og=;
        b=I4RXjzTEjYZLScLmtUejt5VscujOrHLN4sYA599qRI44dgjgduIa2vSZTAZYR2P5Rg
         NVf5SItpDRtvMu3z6KdKvHcHONOgAec/Jkird+Q0L+ZPo+U6dG4/N3p23tPVpQaqrCsw
         IFwmLqboZgHgOEssMnsZxBKoRs/aqMdQJtZxXrs3pkJjmF8U93+HSzmAnooH+fXknQbX
         wgTOJN8RbPTqL7ttah7Oqg3J9nwdFU37h8kVHPH5pa5m892UUjpHKYtLjv2thWcIQgPT
         RZSrVwPwszEPPgIxrKmcyR9LFXH4cDGp5o3wwq6eSgWt8ifleBi5FWFjnBY591PF+qbV
         cT/A==
X-Gm-Message-State: APjAAAU9a0hOiIkWMHONcjhYMALKleG58MJH6PPbD6r+aEkTwR7H4cte
        qseVplYoxJ/TQ313PVOcrYmclT1kpBuwadfjGVU0m1Xz8ft9pQ==
X-Google-Smtp-Source: APXvYqzRDMQ/N0I6iPQwhcOP3AbejKkDuEyNU3oGQqTePYQI1cQ72GbFpp2HkwYs1JCf9y4d6QPpI1pUC2pBwmFoIwU=
X-Received: by 2002:a5e:a811:: with SMTP id c17mr13764040ioa.122.1567117602524;
 Thu, 29 Aug 2019 15:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com> <20190829205635.20189-3-krish.sadhukhan@oracle.com>
In-Reply-To: <20190829205635.20189-3-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Aug 2019 15:26:31 -0700
Message-ID: <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section "Checks on Guest Control Registers, Debug Registers, and
> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> of nested guests:
>
>     If the "load debug controls" VM-entry control is 1, bits 63:32 in the DR7
>     field must be 0.

Can't we just let the hardware check guest DR7? This results in
"VM-entry failure due to invalid guest state," right? And we just
reflect that to L1?
