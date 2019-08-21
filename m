Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD7C984D0
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 21:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfHUTuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 15:50:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46286 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730146AbfHUTuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 15:50:44 -0400
Received: by mail-io1-f68.google.com with SMTP id x4so6992281iog.13
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 12:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rtFGKBgCd1TZut+zMz8eGkPWN4Ft5SXhOxAqFSaWHTk=;
        b=F/+Oa6AljcaGT7AZMMaoHJd1qxFfBdS3akg968hI3bNA0qDODwf2moe703nCp58sD9
         AsUfjNQWG3JzM1GSV8TwP4ChDRj059cD/M8lD7yx7gc6b2moS2fpfnICTM95WgLIU2XN
         OyHZwVpyXcyie/YXvBzvU6Cvsy5XSJ0UZXIe1zter7TbnV0oGW+Pw/zCVmW8HOEuKYxh
         Xh4q+kxb4qJE8HkhdsSDBhyNo/91Ezp5TcOrJW6XTU2QnL3NnzCLzlW7nq+C6MfkwY6+
         g4Kq9MJnldm2UxtK4H/fQGbxJwnYB5ePs3sUTZ9KfjValH9wVqiFQrvND1KNTKPBq4oS
         PREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rtFGKBgCd1TZut+zMz8eGkPWN4Ft5SXhOxAqFSaWHTk=;
        b=BNUTmltSEIliTuwbKy3oIIKsDuWJZrJzU6K+PLso8AYgsOYGVOhl6SBIwTc5zItDy9
         FHmPp2XiDuGIXeDlB1pEh3lmuZJJn1R1U8aPYip3K5YqxD3CflBGfZiUcvZtOydjQsdY
         0q8JvjCBCBvmvo8RxBftKYeA5pNOfZU53MaKc2tPA1q0VO2OiInPdK5B4Tp5ZD2972Zq
         krZh5SPRdZ0E8sfUvIBOZZjbv45+bPs+Ylz1ZIoo2H1CB9ylMGwc5Ck617l2fYKfqahO
         24a3/7OJbisuCErib+AGp2Wtcv62uQxEew0wZRYHMjZ/ObYr0iKNYc5fp14VXS4dOhN9
         HSHA==
X-Gm-Message-State: APjAAAUAqW4jIorUrcaTfNLhOiXj3w/xr3Kw/ucqRwl5goNrwCLnWL2Y
        tkz7vGItZYyJZ0kaF/JiXEPLMve4S/IEqlsESi9d6IRb65w=
X-Google-Smtp-Source: APXvYqzpUITfJ3aXOdZQ9dZBQM356Go1zU9atNXqTDKkgL8ORnAumj05GaV1+zfZR91j+q9m67jjAOrHiu07IPGUEsk=
X-Received: by 2002:a5e:c911:: with SMTP id z17mr11100339iol.119.1566417043038;
 Wed, 21 Aug 2019 12:50:43 -0700 (PDT)
MIME-Version: 1.0
References: <1566315384-34848-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1566315384-34848-1-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Aug 2019 12:50:32 -0700
Message-ID: <CALMp9eSVyTY5k3r-KAAVa4Wft=ruzvJV6F3PkEDvYiYPYEZyJA@mail.gmail.com>
Subject: Re: [PATCH] selftests: kvm: fix state save/load on processors without XSAVE
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 20, 2019 at 8:36 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> state_test and smm_test are failing on older processors that do not
> have xcr0.  This is because on those processor KVM does provide
> support for KVM_GET/SET_XSAVE (to avoid having to rely on the older
> KVM_GET/SET_FPU) but not for KVM_GET/SET_XCRS.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
