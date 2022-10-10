Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF005F9FB6
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 15:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJJN5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 09:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiJJN5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 09:57:10 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC416D9E1;
        Mon, 10 Oct 2022 06:57:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id bk15so17137020wrb.13;
        Mon, 10 Oct 2022 06:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LoUiMfmEnN9CtUaXVzPZjr+vlbcco3+KEqK1em9Pmho=;
        b=cKCUvEpSaWkOXUXxbWypqyLEcOlAoVbGQrUqD08+qNY3YLFYq5bol+nkMfrsJqZl2i
         c0WflFNIar1l9IE+w2LfdP2cp3HxuHsuVfVodASK62r8DWBZaZZZfJbI9D+yoe4BO7AB
         geUus8GFUwkhzUo/UhwpzBjGUv/g+XVTND37bt94MdmrUEnXxI7hHogCMPRNhk+HAc3m
         cO1dOfouarSaZtHgPxXsEN7pKpuOLEVkarAL3Q5tCSplGIycCKCbuKKkhVq1ISrDMDTT
         NSoj1tDvbaKJO90XJ8+Cj6kk3Z6rh3cZCTPB47tsfIy/mhmmiv7cpS7wyZAWR+vUhihW
         YE1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LoUiMfmEnN9CtUaXVzPZjr+vlbcco3+KEqK1em9Pmho=;
        b=G+yX2NOI62RR3ZkkZORS716So2gy+CIzFTybCcJU6vWIyNRu41D8Tfy8Y+qJzWFSaQ
         ur9dWaGy3eGJufeqJxEjbvkkJKF7Op3u/iHW8+dOuIGh4Gpo+Sl9FWdpwwkFzu3trx9C
         rEXSfxvOWlUkwMrIPsh6H6Le6LJJ8uSmme+kOJ6SCXWWdER58h0wzW6w4CHBaujcDgHd
         0ecGA+ba8AMI4yHgehxnlDFqz9BoEkOiwBIQ7x44UqLcnHrvRFlMdTagTw376d08bc8Y
         LIudfcI+d02UMYmYbdG6y6208pw7HkpJkQcYGd+o3oO5wH2tu3zWLApG84HvKtAm1I07
         zpQw==
X-Gm-Message-State: ACrzQf2Jy1ucN8Fovo9ittLHMe4NqhaJOfrYLPAGr29DcMp2fCodMRzJ
        qGO4ktxqRQe0YdzUtmsAZE8PHI06jCBZLTkVlk/9dT8IpCQ=
X-Google-Smtp-Source: AMsMyM4rc02AveqREQPsOjS+iLcrK0FZ/Kq29LVjCkoRiMbErFYzYeqCOebLpHoGcSgLrytz+/Rm++OD6Rx2BTb5feg=
X-Received: by 2002:a05:6000:1f8e:b0:230:816f:3175 with SMTP id
 bw14-20020a0560001f8e00b00230816f3175mr3368263wrb.691.1665410224957; Mon, 10
 Oct 2022 06:57:04 -0700 (PDT)
MIME-Version: 1.0
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Mon, 10 Oct 2022 09:56:53 -0400
Message-ID: <CAMdYzYrUOoTmBL2c_+=xLBMXg38Pp4hANnzqxoe1cVDDrFvqTA@mail.gmail.com>
Subject: [BUG] KVM USB passthrough did not claim interface before use
To:     kvm@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good Morning,

I've run into a bug with a new usb device when attempting to pass
through using qemu-kvm. Another device is passed through without
issue, and qemu spice passthrough does not exhibit the issue. The usb
device shows up in the KVM machine, but is unusable. I'm unsure if
this is a usbfs bug, a qemu bug, or a bug in the device driver.

usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
before use
usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
before use
usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 1
before use
usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
before use
usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 0
before use
usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 0
before use

The host system is Ubuntu 22.04.
The qemu version is as shipped: QEMU emulator version 6.2.0 (Debian
1:6.2+dfsg-2ubuntu6.3)
The host kernel version is: 5.15.0-48-generic #54-Ubuntu SMP Fri Aug
26 13:26:29 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

The VM is HomeAssistant, running kernel 5.15.67. Issue was also
observed on kernel version 5.10.

The device in question is:
Bus 003 Device 006: ID 1cf1:0030 Dresden Elektronik ZigBee gateway [ConBee II]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.01
  bDeviceClass            2 Communications
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1cf1 Dresden Elektronik
  idProduct          0x0030 ZigBee gateway [ConBee II]
  bcdDevice            1.00
  iManufacturer           1 dresden elektronik ingenieurtechnik GmbH
  iProduct                2 ConBee II
  iSerial                 3 DE2597089
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0043
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0
      CDC Header:
        bcdCDC               1.10
      CDC ACM:
        bmCapabilities       0x02
          line coding and serial state
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              16
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength       0x000c
  bNumDeviceCaps          1
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000002
      HIRD Link Power Management (LPM) Supported
Device Status:     0x0000
  (Bus Powered)

Very Respectfully,
Peter Geis
