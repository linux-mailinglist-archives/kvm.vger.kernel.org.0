Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1CE6E16A3
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 23:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjDMVqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 17:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDMVqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 17:46:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6B259C3
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 14:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681422324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9vOAI4hbAicFAA60hsvqdhfDss0Ylqv6HldesoU/tJY=;
        b=b5D24GTQxF+ndqTssQXAujEm9mo/aMGSFT9jcBQW81+zvFJX+KthXo9ynHsKF80j2oTGQG
        5bubJqxNlfLr0DtrX6H6ZlBc4R3mvm6Z33oDpQy+U4xnjkxw6CsbqNLoJWeHKbR+/AE0Z8
        VY/4KHLGIOP+xE8Ult2VcS/OEpQhQuk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-UW8WilBIOeimRhNO5tpYqQ-1; Thu, 13 Apr 2023 17:45:23 -0400
X-MC-Unique: UW8WilBIOeimRhNO5tpYqQ-1
Received: by mail-pg1-f199.google.com with SMTP id l65-20020a639144000000b005091ec4f2d4so7021506pge.20
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 14:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681422322; x=1684014322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9vOAI4hbAicFAA60hsvqdhfDss0Ylqv6HldesoU/tJY=;
        b=iDXiwAcw1fBNqAe7PaddKWl5ZVTuKEbOBu2cpLpC95+aKLKz185cyD2EvIo7z3B1s3
         zSZQWVb70LIInNZvPQo7yDPlL3AN8SZ61AB+HDDGYwRefxdtlS4iGNTZK9aDZ/7ZF7GT
         Vdu98Gog29Ns9WYQX005w/Qg3QY/6+jJNVaS+wZvub9nq8j4l47KFIG/Jg2+YHhx4FsU
         FjW+VqnkoFeKECZrToZlGMA0DoioPUP4A3Ga4iorPtIZ1tI5sg/NO+7REViPIACauk7J
         8sFzXPA2bPtBVg1pEDWZWsz2/pZy9q6JINv98PL0WzfXMOynOpgTBYHqXviDGhgL3kww
         G6gg==
X-Gm-Message-State: AAQBX9ciiWjHmKWwTHI5Dr5WZg3u0TTnSv+afHoaH4o1CgoKmUATqQbC
        h0lTBYqeYDXDsjEers3rZvTTX1ornZHii2vfVBFs6dVEaLGK1/rQajMUioW/BLXquFpsG6WVTW/
        c9uXa1GskXoIXGhwnY+NSnDwQdnenG1L5qwWV
X-Received: by 2002:a17:902:d2c7:b0:1a0:4321:920e with SMTP id n7-20020a170902d2c700b001a04321920emr136878plc.12.1681422322496;
        Thu, 13 Apr 2023 14:45:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350bbra8lxir7fYCK6ZR40qL56WgEcSrFjv5l2/KQ926Swjz600KOcWMzMve3Fg1XTX93A3R0pJfAyX+8tlT9ysg=
X-Received: by 2002:a17:902:d2c7:b0:1a0:4321:920e with SMTP id
 n7-20020a170902d2c700b001a04321920emr136870plc.12.1681422322272; Thu, 13 Apr
 2023 14:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230413214327.3971247-1-jsnow@redhat.com>
In-Reply-To: <20230413214327.3971247-1-jsnow@redhat.com>
From:   John Snow <jsnow@redhat.com>
Date:   Thu, 13 Apr 2023 17:45:11 -0400
Message-ID: <CAFn=p-aEozt=1vBjGT6DQ0=_VgVP9dRTvFJcsvPU5U0ghcvOAg@mail.gmail.com>
Subject: Re: [PATCH] tests/avocado: require netdev 'user' for kvm_xen_guest
To:     qemu-devel@nongnu.org
Cc:     Beraldo Leal <bleal@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 5:43=E2=80=AFPM John Snow <jsnow@redhat.com> wrote:
>
> The tests will fail mysteriously with EOFError otherwise, because the VM
> fails to boot and quickly disconnects from the QMP socket. Skip these
> tests when we didn't compile with slirp.
>

Full disclosure: I only tested this patch in conjunction with a much
larger series that also messed around with tests, but it seemed to
work OK on my local machine in that circumstance. Didn't find any
other tests that needed this same treatment.

--js

> Fixes: c8cb603293fd (tests/avocado: Test Xen guest support under KVM)
> Signed-off-by: John Snow <jsnow@redhat.com>
> ---
>  tests/avocado/kvm_xen_guest.py | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest=
.py
> index 5391283113..171274bc4c 100644
> --- a/tests/avocado/kvm_xen_guest.py
> +++ b/tests/avocado/kvm_xen_guest.py
> @@ -45,6 +45,7 @@ def get_asset(self, name, sha1):
>      def common_vm_setup(self):
>          # We also catch lack of KVM_XEN support if we fail to launch
>          self.require_accelerator("kvm")
> +        self.require_netdev('user')
>
>          self.vm.set_console()
>
> --
> 2.39.2
>

