Return-Path: <kvm+bounces-3105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE8E8009CC
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 12:22:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C1121F20F5E
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187D121360;
	Fri,  1 Dec 2023 11:22:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2a07:de40:b251:101:10:150:64:1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD02CF
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 03:22:25 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B92E021C5A;
	Fri,  1 Dec 2023 11:22:23 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 94C941369E;
	Fri,  1 Dec 2023 11:22:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8TfwIO7BaWXIcwAAD6G6ig
	(envelope-from <cfontana@suse.de>); Fri, 01 Dec 2023 11:22:22 +0000
Message-ID: <0c045de3-7701-d562-bfe6-84e71964aebd@suse.de>
Date: Fri, 1 Dec 2023 12:22:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 03/70] RAMBlock/guest_memfd: Enable
 KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
 David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Xiaoyao Li
 <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-4-xiaoyao.li@intel.com>
 <bc84fa4f-4866-4321-8f30-1388eed7e64f@redhat.com>
 <05f0e440-36a2-4d3a-8caa-842b34e50dce@intel.com>
 <0fbfc413-7c74-4b2a-bade-6f3f04ca82c2@redhat.com>
 <4708c33a-bb8d-484e-ac7b-b7e8d3ed445a@intel.com>
 <45d28654-9565-46df-81b9-6563a4aef78c@redhat.com>
 <ZWixXm-sboNZ-mzG@google.com>
 <d6bfd8be-7e8c-4a95-9e27-31775f8e352e@redhat.com>
 <ZWjLo57peucZMQIh@redhat.com>
From: Claudio Fontana <cfontana@suse.de>
In-Reply-To: <ZWjLo57peucZMQIh@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=suse.de (policy=none);
	spf=softfail (smtp-out1.suse.de: 2a07:de40:b281:104:10:150:64:97 is neither permitted nor denied by domain of cfontana@suse.de) smtp.mailfrom=cfontana@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [4.45 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 DMARC_POLICY_SOFTFAIL(0.10)[suse.de : No valid SPF, No valid DKIM,none];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-0.84)[-0.839];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 BAYES_HAM(-3.00)[100.00%];
	 RCVD_COUNT_THREE(0.00)[3];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_TWELVE(0.00)[21];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[google.com,intel.com,redhat.com,gmail.com,linaro.org,nongnu.org,vger.kernel.org,amd.com];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Score: 4.45
X-Rspamd-Queue-Id: B92E021C5A

On 11/30/23 18:51, Daniel P. Berrangé wrote:
> On Thu, Nov 30, 2023 at 05:54:26PM +0100, David Hildenbrand wrote:
>> On 30.11.23 17:01, Sean Christopherson wrote:
>>> On Thu, Nov 30, 2023, David Hildenbrand wrote:
>>>> On 30.11.23 08:32, Xiaoyao Li wrote:
>>>>> On 11/20/2023 5:26 PM, David Hildenbrand wrote:
>>>>>>
>>>>>>>> ... did you shamelessly copy that from hw/virtio/virtio-mem.c ? ;)
>>>>>>>
>>>>>>> Get caught.
>>>>>>>
>>>>>>>> This should be factored out into a common helper.
>>>>>>>
>>>>>>> Sure, will do it in next version.
>>>>>>
>>>>>> Factor it out in a separate patch. Then, this patch is get small that
>>>>>> you can just squash it into #2.
>>>>>>
>>>>>> And my comment regarding "flags = 0" to patch #2 does no longer apply :)
>>>>>>
>>>>>
>>>>> I see.
>>>>>
>>>>> But it depends on if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE will appear together
>>>>> with initial guest memfd in linux (hopefully 6.8)
>>>>> https://lore.kernel.org/all/CABgObfa=DH7FySBviF63OS9sVog_wt-AqYgtUAGKqnY5Bizivw@mail.gmail.com/
>>>>>
>>>>
>>>> Doesn't seem to be in -next if I am looking at the right tree:
>>>>
>>>> https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=next
>>>
>>> Yeah, we punted on adding hugepage support for the initial guest_memfd merge so
>>> as not to rush in kludgy uABI.  The internal KVM code isn't problematic, we just
>>> haven't figured out exactly what the ABI should look like, e.g. should hugepages
>>> be dependent on THP being enabled, and if not, how does userspace discover the
>>> supported hugepage sizes?
>>
>> Are we talking about THP or hugetlb? They are two different things, and
>> "KVM_GUEST_MEMFD_ALLOW_HUGEPAGE" doesn't make it clearer what we are talking
>> about.
>>
>> This patch here "get_thp_size()" indicates that we care about THP, not
>> hugetlb.
>>
>>
>> THP lives in:
>> 	/sys/kernel/mm/transparent_hugepage/
>> and hugetlb in:
>> 	/sys/kernel/mm/hugepages/
>>
>> THP for shmem+anon currently really only supports PMD-sized THP, that size
>> can be observed via:
>> 	/sys/kernel/mm/transparent_hugepage/hpage_pmd_size
>>
>> hugetlb sizes can be detected simply by looking at the folders inside
>> /sys/kernel/mm/hugepages/. "tools/testing/selftests/mm/vm_util.c" in the
>> kernel has a function "detect_hugetlb_page_sizes()" that uses that interface
>> to detect the sizes.
>>
>>
>> But likely we want THP support here. Because for hugetlb, one would actually
>> have to instruct the kernel which size to use, like we do for memfd with
>> hugetlb.
> 
> Would we not want both ultimately ?
> 
> THP is good because it increases performance vs non-HP out of the box
> without the user or mgmt app having to make any decisions.
> 
> It does not give you deterministic performance though, because it has
> to opportunistically assign huge pages basd on what is available and
> that may differ each time a VM is launched.  Explicit admin/mgmt app
> controlled huge page usage gives determinism, at the cost of increased
> mgmt overhead.
> 
> Both are valid use cases depending on the tradeoff a deployment and/or
> mgmt app wants to make.

Absolutely, it really depends on the definition of "performance" for the specific goal the user is trying to achieve.
There are very prominent use cases where THP is a big no-no due to the latency introduced.

C

