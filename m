Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87984A978C
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 02:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbfIEAP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 20:15:57 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42388 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIEAP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 20:15:57 -0400
Received: by mail-oi1-f193.google.com with SMTP id o6so300936oic.9;
        Wed, 04 Sep 2019 17:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sifjxETRYiP3/dI94LWW+EPsjWJBvoBD1awu87P5YhM=;
        b=CX6NCYFoE0gXba0Ao/upp+gvt8TOaazyHEYHn3cYWF3MLq614j1a2vlELwKOyGPX8V
         nFH8Do2s50msebXYbJwxi5oc6EMtv5NfIPNFb7frNHMkUc4hTKlfBbUoWfS/FBJz2oWO
         e+cW5DJOl4CF7bsHkuqwOOtQagDsAglF+05dxJCxSQkVPoOGNqZ3+UjW8w/I3vG9URgZ
         tQ9GzOEyDl7ROQAi/nXPca5VscXKhlr8n+ILWCX8g4OyeQt6ZEaOvd9VuuojxuF0y9HW
         WhtM2va9pY/NHejYj9+nZz7dn0krZZg8GyzcUvjDmWTKTd3Hfxfz+NrYLaT/9MOW1neY
         dh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sifjxETRYiP3/dI94LWW+EPsjWJBvoBD1awu87P5YhM=;
        b=Rr0hKdHUpzXWZZx5oi9QVNXgtX0f0c6an/cZnKnOdKEHE9TmKmshZrNyeTz/ZakAsj
         RbBDrdX7jyeGytKQtlNw/c7XQd+xw9cuipVe/tG9ZWmAwAMOtvEQlnMQ9vPy/pTmS14p
         qRNpx8TIpeDIZo0AU6zAXAVGHD9qN6Hp3d711xEx8koF+B56t+5qATx51S9MsJLz4+f0
         Md6+LOBVuv/1vLgQjs3R0b6SfMvXJjaTUW1tfBKeT5a0bEOKstXxaYWGDqv4EPKJma3x
         IkxsT1LaV2EIDcRG2CnsF5HThOlUoX9GfIQP6eb0w/rca+90tgNiAZ4QvkONbprckmEE
         nqAA==
X-Gm-Message-State: APjAAAUJXB/LAcoI0K0YM7gaELC7rCfp254NP4Juv1neb/rNIMdVQvLE
        fTzJ+FgV/j8B5oINe6fQvSZRaDzmjMZ/1WN4QWE=
X-Google-Smtp-Source: APXvYqy6DO2HoL48JbpGVvb47rr337PM1oVuO/LS/a0NiV3grYCFIM824yV6VZ5S2cHKBMOzEOEfD71uHAnVuFBsewY=
X-Received: by 2002:aca:5a84:: with SMTP id o126mr564762oib.5.1567642556538;
 Wed, 04 Sep 2019 17:15:56 -0700 (PDT)
MIME-Version: 1.0
References: <1567068597-22419-1-git-send-email-wanpengli@tencent.com> <a70aeec2-1572-ea09-a0c5-299cd70ddc8a@intel.com>
In-Reply-To: <a70aeec2-1572-ea09-a0c5-299cd70ddc8a@intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 5 Sep 2019 08:15:44 +0800
Message-ID: <CANRm+Czb07GGy7pP2NRLhaXV4yy01ozdqH34CTSMCSJPR1ZfPw@mail.gmail.com>
Subject: Re: [PATCH v2] cpuidle-haltpoll: Enable kvm guest polling when
 dedicated physical CPUs are available
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 4 Sep 2019 at 17:48, Rafael J. Wysocki
<rafael.j.wysocki@intel.com> wrote:
>
> On 8/29/2019 10:49 AM, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > The downside of guest side polling is that polling is performed even
> > with other runnable tasks in the host. However, even if poll in kvm
> > can aware whether or not other runnable tasks in the same pCPU, it
> > can still incur extra overhead in over-subscribe scenario. Now we can
> > just enable guest polling when dedicated pCPUs are available.
> >
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> As stated before, I'm going to queue up this change for 5.4, with the
> Paolo's ACK.
>
> BTW, in the future please CC power management changes to
> linux-pm@vger.kernel.org for easier handling.

Ok, thanks.

Wanpeng
