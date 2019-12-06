Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A471159C2
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLFXtK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:49:10 -0500
Received: from sender4-of-o50.zoho.com ([136.143.188.50]:21036 "EHLO
        sender4-of-o50.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfLFXtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:49:10 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1575676138; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=AmH8Mzg7pWaYVEzE4knc/JjgZCnz/U9oRW7aaFLkcu4CBSbKEB9IJC96+p2X82+Wb1+iziy34LvGEUGH6fD/0eFLBexvc4HdA9PB227QDtgPgy1J83/Fdz8cy3op6NFMLlIBm9SAdGOzosv40262ZYDj/3xSuajxwFUzQInYVTE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1575676138; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=E1jlx6HZE4rmafsjKWjU2SJkYMh4I37w9SK1XsVquGA=; 
        b=OA/FACuChlwaat1dUMe8IHWhiYVzhS32kIlPtoRlMjU+LIp2dHDY8GmBSM+8RsiOwYnCXSO7yFlugO9IMweL99ABkkZUl/CqfqeIxhWyGeJLwaQNMqHzmyQYfCNHx8p4nu0sRWMhNGqjR2RVJ/68e8j3+pokhqQc3fCi+h6fDJ0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=patchew.org;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1575676137139446.59853742157395; Fri, 6 Dec 2019 15:48:57 -0800 (PST)
In-Reply-To: <1575627817-24625-1-git-send-email-catherine.hecx@gmail.com>
Reply-To: <qemu-devel@nongnu.org>
Subject: Re: [PATCH] target/i386: skip kvm_msr_entry_add when kvm_vmx_basic is 0
Message-ID: <157567613553.744.12283750572800820793@37313f22b938>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     catherine.hecx@gmail.com
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, catherine.hecx@gmail.com, ehabkost@redhat.com,
        kvm@vger.kernel.org, rth@twiddle.net
Date:   Fri, 6 Dec 2019 15:48:57 -0800 (PST)
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8xNTc1NjI3ODE3LTI0NjI1LTEt
Z2l0LXNlbmQtZW1haWwtY2F0aGVyaW5lLmhlY3hAZ21haWwuY29tLwoKCgpIaSwKClRoaXMgc2Vy
aWVzIHNlZW1zIHRvIGhhdmUgc29tZSBjb2Rpbmcgc3R5bGUgcHJvYmxlbXMuIFNlZSBvdXRwdXQg
YmVsb3cgZm9yCm1vcmUgaW5mb3JtYXRpb246CgpTdWJqZWN0OiBbUEFUQ0hdIHRhcmdldC9pMzg2
OiBza2lwIGt2bV9tc3JfZW50cnlfYWRkIHdoZW4ga3ZtX3ZteF9iYXNpYyBpcyAwClR5cGU6IHNl
cmllcwpNZXNzYWdlLWlkOiAxNTc1NjI3ODE3LTI0NjI1LTEtZ2l0LXNlbmQtZW1haWwtY2F0aGVy
aW5lLmhlY3hAZ21haWwuY29tCgo9PT0gVEVTVCBTQ1JJUFQgQkVHSU4gPT09CiMhL2Jpbi9iYXNo
CmdpdCByZXYtcGFyc2UgYmFzZSA+IC9kZXYvbnVsbCB8fCBleGl0IDAKZ2l0IGNvbmZpZyAtLWxv
Y2FsIGRpZmYucmVuYW1lbGltaXQgMApnaXQgY29uZmlnIC0tbG9jYWwgZGlmZi5yZW5hbWVzIFRy
dWUKZ2l0IGNvbmZpZyAtLWxvY2FsIGRpZmYuYWxnb3JpdGhtIGhpc3RvZ3JhbQouL3NjcmlwdHMv
Y2hlY2twYXRjaC5wbCAtLW1haWxiYWNrIGJhc2UuLgo9PT0gVEVTVCBTQ1JJUFQgRU5EID09PQoK
VXBkYXRpbmcgM2M4Y2Y1YTljMjFmZjg3ODIxNjRkMWRlZjdmNDRiZDg4ODcxMzM4NApTd2l0Y2hl
ZCB0byBhIG5ldyBicmFuY2ggJ3Rlc3QnCjk4NzQ0MWYgdGFyZ2V0L2kzODY6IHNraXAga3ZtX21z
cl9lbnRyeV9hZGQgd2hlbiBrdm1fdm14X2Jhc2ljIGlzIDAKCj09PSBPVVRQVVQgQkVHSU4gPT09
CkVSUk9SOiBjb2RlIGluZGVudCBzaG91bGQgbmV2ZXIgdXNlIHRhYnMKIzM4OiBGSUxFOiB0YXJn
ZXQvaTM4Ni9rdm0uYzoyNjM3OgorXkkvKiBPbmx5IGFkZCB0aGUgZW50cnkgd2hlbiBob3N0IHN1
cHBvcnRzIGl0ICovJAoKdG90YWw6IDEgZXJyb3JzLCAwIHdhcm5pbmdzLCAxNCBsaW5lcyBjaGVj
a2VkCgpDb21taXQgOTg3NDQxZjc0MjRjICh0YXJnZXQvaTM4Njogc2tpcCBrdm1fbXNyX2VudHJ5
X2FkZCB3aGVuIGt2bV92bXhfYmFzaWMgaXMgMCkgaGFzIHN0eWxlIHByb2JsZW1zLCBwbGVhc2Ug
cmV2aWV3LiAgSWYgYW55IG9mIHRoZXNlIGVycm9ycwphcmUgZmFsc2UgcG9zaXRpdmVzIHJlcG9y
dCB0aGVtIHRvIHRoZSBtYWludGFpbmVyLCBzZWUKQ0hFQ0tQQVRDSCBpbiBNQUlOVEFJTkVSUy4K
PT09IE9VVFBVVCBFTkQgPT09CgpUZXN0IGNvbW1hbmQgZXhpdGVkIHdpdGggY29kZTogMQoKClRo
ZSBmdWxsIGxvZyBpcyBhdmFpbGFibGUgYXQKaHR0cDovL3BhdGNoZXcub3JnL2xvZ3MvMTU3NTYy
NzgxNy0yNDYyNS0xLWdpdC1zZW5kLWVtYWlsLWNhdGhlcmluZS5oZWN4QGdtYWlsLmNvbS90ZXN0
aW5nLmNoZWNrcGF0Y2gvP3R5cGU9bWVzc2FnZS4KLS0tCkVtYWlsIGdlbmVyYXRlZCBhdXRvbWF0
aWNhbGx5IGJ5IFBhdGNoZXcgW2h0dHBzOi8vcGF0Y2hldy5vcmcvXS4KUGxlYXNlIHNlbmQgeW91
ciBmZWVkYmFjayB0byBwYXRjaGV3LWRldmVsQHJlZGhhdC5jb20=

