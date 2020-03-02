Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68BF1764B6
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 21:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgCBUNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 15:13:11 -0500
Received: from mail-qt1-f174.google.com ([209.85.160.174]:40844 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCBUNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 15:13:11 -0500
Received: by mail-qt1-f174.google.com with SMTP id o10so990234qtr.7
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 12:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=0eFo90vowkQ//n5Sm8HSsjwuDZ8O2rscJrJ7W+9BphU=;
        b=aBpbpDeytpAA9bsazio8o/mPLMo8EHuvLjvEKRzzljIeIK/VBGE/C0rh2jmgnX6ld9
         /kUUj+BQxTRbjY63fxZdeLuiX2qImU8bIZS1v7rcFIlJGT4L246OE3gXKhg+NlST69Ib
         1LDNlqcPawyQ8NYZZ6Hy2n6KlfqSyL3n/D2p+YucbNWhcehG+bh0BfFyGSehjmwLrEHC
         +BRNc3A8NreG2N4HmrhAE9SIFBT7nIIm851ZpOEgyapv+cez8wHRe+3ATTrr3T51Hl7Z
         AFg0WQzy2RSIWoGULhDC6pnPpqWrsaeKi8ro/pXklBomuBDrDYmSCNS7oFQpVs4ug0pi
         ro7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0eFo90vowkQ//n5Sm8HSsjwuDZ8O2rscJrJ7W+9BphU=;
        b=MJ29AecrMZNRyPyyV6h44h7RLU9zt7XIQXVuwBKZ+xrGg04Af2QkEKjX8Yiw2eCfl6
         igo+4D9qGmER5vH10vuSyoP4VGBjua+PNZm7ip8i5aMF4fa+VAreyRwrhZFqAuWy3RnH
         5frzcmBcOsZTQNDFIfsyqtGH3PzkkJajn8H+YiXrfOyoayOz0b9ona9YZef4mn+j8YHo
         baBDuOj1uQ4uUAzn6y/Yj3INn9sjry0HQ8inE21OgJADRAdeuOp1niNSVFCAmC5eWHjb
         zIztI4dUIzfFV1efGOCpnRDIe38ocsYGj0HP7hg/scs8O+7QZh0XgmohtDHVsmw/4XUw
         xi2Q==
X-Gm-Message-State: ANhLgQ06HSU5XWxmEVATYpbIsXCL3+pmMxs4fGVmsjY7U3dTkhWz0xqX
        8O7FdpP14sJ0QosQsnos2KHL6jHSUGis9608tnCeXmX8
X-Google-Smtp-Source: ADFU+vuBI6ZxcNuvA5rfTBvEBWnWE/135RIgkm0ps1Xe+2zDrivkMcXIIoLsu4H2PqCnz9gyN2tTcOWvufQD3hncBwQ=
X-Received: by 2002:ac8:5452:: with SMTP id d18mr1399240qtq.43.1583179988255;
 Mon, 02 Mar 2020 12:13:08 -0800 (PST)
MIME-Version: 1.0
From:   Satish Patel <satish.txt@gmail.com>
Date:   Mon, 2 Mar 2020 15:12:57 -0500
Message-ID: <CAPgF-fpYbaCvHsLfJJjb4AnMjCBv7HanZRpxcqiZvBZObHHMww@mail.gmail.com>
Subject: kvm exposing wrong CPU Topology to guest vm
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Folks,

I am having major performance issue with my Erlang application running
on openstack KVM hypervisor and after so many test i found something
wrong with my KVM guest CPU Topology

This is KVM host - http://paste.openstack.org/show/790120/
This is KVM guest - http://paste.openstack.org/show/790121/

If you carefully observe output of both host and guest you can see
guest machine threads has own cache that is very strange

L2 L#0 (4096KB) + Core L#0
      L1d L#0 (32KB) + L1i L#0 (32KB) + PU L#0 (P#0)
      L1d L#1 (32KB) + L1i L#1 (32KB) + PU L#1 (P#1)

I believe because of that my erlang doesn't understand topology and
going crazy..

I have Ali Cloud and AWS and when i compare with them they are showing
correct CPU Topology the way physical machine showing, something is
wrong with my KVM look like.

I am running qemu-kvm-2.12 on centos 7.6 and i have tune my KVM at my
best level, like CPU vining, NUMA and cpu host-passthrough.

Thanks in advance for your help.
